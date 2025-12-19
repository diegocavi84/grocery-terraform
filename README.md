# Dashboard CPU – Terraform Infrastructure

Dashboard de CPU simulada con AWS Lambda, CloudWatch y S3, desplegado con Terraform.

## 🗺️ Arquitectura

```mermaid
flowchart LR
    User([User]) --&gt; S3[S3 Static Website]
    User --&gt; Dashboard[CloudWatch Dashboard]
    EventBridge[EventBridge 1 min] --&gt; Lambda[Lambda Health]
    Lambda --&gt; CloudWatch[CloudWatch Metrics]
    Terraform[Terraform CLI] --&gt; S3
    Terraform --&gt; Lambda
    Terraform --&gt; EventBridge
    Terraform --&gt; CloudWatch

🛠️ Arquitectura
AWS Lambda: Función que envía métricas de CPU a CloudWatch.
Amazon CloudWatch: Dashboard público con gráficas de CPU.
Amazon S3: Hosting estático de la página web.
Amazon EventBridge: Trigger cada 1 minuto.
Terraform: Infraestructura como código.
🚀 Deployment Instructions
Prerequisites
Terraform ≥ 1.14
AWS cuenta con credenciales configuradas.
Deployment Steps

Inicializar Terraform:
bash
Copy
terraform init
terraform apply
Subir la página web:
bash
Copy
aws s3 cp src/ s3://$(terraform output -raw bucket_name)/ --recursive

bash
Copy
aws s3 cp src/ s3://$(terraform output -raw bucket_name)/ --recursive

🗺️ Demo
Tienda online: http://grocery-cloud-123-456.s3-website-us-east-1.amazonaws.com
Dashboard: [https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=Grocery-Health](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=Grocery-Health]
🛠️ Tecnologías
Python 3.12
Terraform ≥ 1.14
AWS (S3, Lambda, CloudWatch, EventBridge)
📸 Capturas de Pantalla
Dashboard: Ver dashboard
Tienda online: Ver tienda
📄 Licencia
MIT © Diego Castillo
