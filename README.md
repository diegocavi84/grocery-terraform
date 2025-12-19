# Grocery Store – Terraform Infrastructure

Serverless grocery store deployed with **Terraform**, featuring **S3 static hosting**, **Lambda health-check**, and **CloudWatch dashboard**.

## 🏪 Live Demo
- **Tienda online**: [http://grocery-cloud-123-456.s3-website-us-east-1.amazonaws.com](http://grocery-cloud-123-456.s3-website-us-east-1.amazonaws.com)
- **Dashboard**: [https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=Grocery-Health](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=Grocery-Health)

## 🏗️ Architecture

<img width="604" height="128" alt="image" src="https://github.com/user-attachments/assets/43d244ef-a03b-4eca-ab36-0189016e9da9" />



🧱 Stack
Table
Copy
Servicio	Uso
Terraform	Infraestructura como código
S3	Hosting estático del frontend (React build)
Lambda	Health-check que envía métricas de CPU
EventBridge	Trigger cada 1 minuto
CloudWatch	Dashboard público con gráficas
💰 Costo
≈ 0,03 USD/mes dentro del AWS Free Tier.

🚀 Quick Start
Clona el repo:
bash
Copy
git clone https://github.com/diegocavi84/grocery-terraform.git
cd grocery-terraform
Configura credenciales AWS:
bash
Copy
aws configure
# Access Key, Secret, Region: us-east-1
Despliega la infraestructura:
bash
Copy
cd terraform
terraform init
terraform apply
Sube el build de React:
bash
Copy
aws s3 cp ../src/frontend/build/ s3://$(terraform output -raw bucket_name)/ --recursive
Abre la tienda:
http://grocery-cloud-123-456.s3-website-us-east-1.amazonaws.com
📁 Project Structure
Copy
grocery-terraform/
├── terraform/          # Infra como código
│   ├── main.tf
│   └── outputs.tf
├── lambda/             # Código Python
│   └── health/health.py
├── src/                # Frontend React (build)
│   └── frontend/build/
├── docs/               # Capturas de pantalla
└── README.md           # Este archivo
📸 Screenshots
Table
Copy
Vista	Enlace
Tienda online	Ver tienda
Dashboard CPU	Ver dashboard
🛠️ Tecnologías
Terraform ≥ 1.5
Python 3.12
React (build estático)
AWS (S3, Lambda, EventBridge, CloudWatch)
📄 Licencia
MIT © Diego Castillo
Copy

---

### ✅ PASO 3 – Guardar y cerrar nano

- **Ctrl + O** → **Enter** (guarda)
- **Ctrl + X** (cierra)

---

### ✅ PASO 4 – Subir a GitHub

```bash
git add README.md
git commit -m "Add professional README with architecture diagram"
git push origin master
