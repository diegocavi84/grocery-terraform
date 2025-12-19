provider "aws" {
  region = "us-east-1"
}

# Bucket para el frontend
resource "aws_s3_bucket" "web" {
  bucket = "grocery-cloud-123-456"
}

# Configuración de sitio web estático
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }
}

# IMPORTANTE: Primero quitar bloqueo de acceso público
resource "aws_s3_bucket_public_access_block" "web_pab" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# IMPORTANTE: Después poner la política pública
resource "aws_s3_bucket_policy" "web_policy" {
  bucket = aws_s3_bucket.web.id
  
  # Dependencia explícita
  depends_on = [aws_s3_bucket_public_access_block.web_pab]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.web.arn}/*"
    }]
  })
}
# ─── HEALTH-CHECK LAMBDA ──────────────────────────────────────────
# IAM role para Lambda
resource "aws_iam_role" "health_lambda_role" {
  name = "health-grocery-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Política básica para Lambda (logs + CloudWatch metrics)
resource "aws_iam_role_policy_attachment" "health_lambda_basic" {
  role       = aws_iam_role.health_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "health_lambda_metrics" {
  role       = aws_iam_role.health_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# Función Lambda
resource "aws_lambda_function" "health" {
  function_name = "health-grocery"
  runtime       = "python3.12"
  handler       = "health.lambda_handler"
  role          = aws_iam_role.health_lambda_role.arn
  filename      = "${path.module}/../lambda/health/health.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/health/health.zip")
  timeout       = 10
}

# EventBridge que dispara la Lambda cada 1 min
resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "health-grocery-every-minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "health_target" {
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = "health"
  arn       = aws_lambda_function.health.arn
}

# Permiso para EventBridge a invocar la Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

