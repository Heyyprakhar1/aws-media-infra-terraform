# 🎬 AWS Media Application Infrastructure

A production-ready Terraform infrastructure for a secure, scalable photo and video storage application on AWS.

## 🏗️ Architecture Overview

This project implements a secure, highly available media storage application with the following components:

### Infrastructure Diagram

🌐 Internet
↓
🛡️ Application Load Balancer
↓
🖥️ Auto Scaling Group (Frontend EC2)
↓
🗄️ Backend Services
↓
💾 S3 Bucket (Media Storage) 📊 DynamoDB (Metadata) 🗃️ RDS MySQL (Transactions)


## 🚀 Features

- **🔒 Security First**: All instances in private subnets, no direct internet access
- **⚡ Auto Scaling**: Handles traffic spikes automatically
- **💾 Secure Storage**: S3 with encryption and Glacier archival
- **📧 Notifications**: SNS email alerts on uploads
- **🌐 High Availability**: Multi-AZ deployment across ap-south-1
- **🔐 IAM Best Practices**: Least privilege access policies

## 📦 Deployed Resources

| Service | Purpose | Configuration |
|---------|---------|---------------|
| **VPC** | Isolated network | 10.0.0.0/16 with public/private subnets |
| **ALB** | Load balancing | Internet-facing, HTTP:80 |
| **EC2** | Frontend servers | t3.micro, Auto Scaling (1-4 instances) |
| **S3** | Media storage | Encrypted, versioned, lifecycle to Glacier |
| **RDS** | Transaction database | MySQL 8.0, db.t3.micro |
| **DynamoDB** | Metadata store | media_id + upload_date keys |
| **SNS** | Notifications | Email alerts for uploads |

## 🛠️ Quick Start

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- AWS account with appropriate permissions

### Deployment
```bash
# Clone repository
git clone https://github.com/Heyyprakhar1/Assignment-for-devops.git
cd Assignment-for-devops

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply

[project-structure.txt](https://github.com/user-attachments/files/22910624/project-structure.txt)
[project-structure.txt](https://github.com/user-attachments/files/22910799/project-structure.txt)


🎯 Live Deployment
Application URL: http://dev-alb-196771817.ap-south-1.elb.amazonaws.com

Deployed Resources:

VPC: vpc-0dd3188ddf4e4a4bf

ALB: dev-alb-196771817.ap-south-1.elb.amazonaws.com

S3 Bucket: dev-media-app-2784add463b78ffd

DynamoDB: dev-media-metadata

RDS: MySQL 8.0 (endpoint in outputs)

🤝 Contributing
Fork the repository

Create a feature branch.

Commit your changes

Push to the branch

Create a Pull Request


⭐ If you find this project helpful, please give it a star! ⭐

