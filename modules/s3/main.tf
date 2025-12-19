# modules/s3/main.tf

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "index_document" {
  description = "Documento de índice"
  type        = string
  default     = "index.html"
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.this.website_endpoint
}
