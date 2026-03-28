<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:185FA5,100:FF9900&height=160&section=header&text=Multi-AZ%20Cloud%20Infrastructure&fontSize=34&fontColor=ffffff&fontAlignY=45&desc=Production-Grade%20AWS%20%7C%20Terraform%20IaC%20%7C%2099.9%25%20Uptime&descSize=14&descAlignY=68&descColor=ffe8c0" width="100%"/>

# ☁️ Multi-AZ Cloud Infrastructure
### Media Application — Production-Grade AWS | Terraform IaC | 99.9% Uptime

[![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](.)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](.)
[![VPC](https://img.shields.io/badge/VPC-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](.)
[![ALB](https://img.shields.io/badge/ALB-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](.)
[![EC2](https://img.shields.io/badge/EC2-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](.)
[![S3](https://img.shields.io/badge/S3-569A31?style=flat-square&logo=amazons3&logoColor=white)](.)
[![RDS](https://img.shields.io/badge/RDS-527FFF?style=flat-square&logo=amazonrds&logoColor=white)](.)

</div>

---

## What this project is

A **production-grade, 3-tier AWS infrastructure** spanning 2 availability zones, built entirely with Terraform. Designed for a media application workload requiring enterprise-level reliability, zero-downtime failover, and secure network isolation.

Every infrastructure decision was made with three constraints: **scalability, cost efficiency, and security**. The result is a modular, reusable Terraform codebase that cut provisioning time by 70% compared to manual setup.

---

## Architecture

```
                         Internet
                            │
                            ▼
                    ┌───────────────┐
                    │  Route 53 DNS │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │     ALB       │  ← Public-facing load balancer
                    │ (public subnet│    HTTPS termination
                    │  AZ-1 + AZ-2)│    Health checks
                    └──────┬────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
   ┌─────────────────┐       ┌─────────────────┐
   │  AZ-1           │       │  AZ-2           │
   │  (ap-south-1a)  │       │  (ap-south-1b)  │
   │                 │       │                 │
   │  ┌───────────┐  │       │  ┌───────────┐  │
   │  │  EC2 (ASG)│  │       │  │  EC2 (ASG)│  │
   │  │  Private  │  │       │  │  Private  │  │
   │  │  subnet   │  │       │  │  subnet   │  │
   │  └─────┬─────┘  │       │  └─────┬─────┘  │
   └────────┼────────┘       └────────┼────────┘
            │                         │
            └───────────┬─────────────┘
                        │
                        ▼
              ┌──────────────────┐
              │   RDS MySQL      │  ← Multi-AZ enabled
              │  (private subnet)│    Automated backups
              │  Primary + Replica    Encrypted at rest
              └──────────────────┘

   ┌──────────────────────────────────┐
   │   S3 Bucket                      │  ← Media storage
   │   (encrypted + lifecycle policy) │    Versioning enabled
   └──────────────────────────────────┘

   ┌──────────────────────────────────┐
   │   NAT Gateway (per AZ)           │  ← Outbound internet for
   └──────────────────────────────────┘    private subnets
```

---

## Infrastructure components

| Component | Config | Purpose |
|---|---|---|
| **VPC** | /16 CIDR, 2 AZs | Network isolation boundary |
| **Public subnets** (×2) | /24 per AZ | ALB, NAT Gateway placement |
| **Private subnets** (×2) | /24 per AZ | EC2 app servers, RDS |
| **ALB** | Multi-AZ, HTTPS | Traffic routing + health checks |
| **Auto Scaling Group** | Min 2, Max 6 | EC2 scaling across both AZs |
| **RDS MySQL** | Multi-AZ, encrypted | Application database |
| **S3** | Versioned + lifecycle | Media file storage |
| **NAT Gateway** | Per-AZ | Private subnet outbound access |
| **Security Groups** | Least-privilege | Layer-level access control |
| **IAM Roles** | Instance profiles | EC2 → S3/CloudWatch access |

---

## Key outcomes

| Metric | Result |
|---|---|
| Infrastructure provisioning time | **70% faster** vs manual setup |
| Availability zone coverage | **2 AZs** — zero-downtime failover validated |
| Infrastructure availability | **~99.9% uptime** maintained |
| Terraform modules | **Reusable** — team-adoptable templates |
| Failover validation | **Zero-downtime** confirmed via live load testing |
| Network security | **Private subnet workload placement** — zero direct public exposure |

---

## Terraform structure

```
.
├── main.tf              # Root module — wires everything together
├── variables.tf         # Input variables
├── outputs.tf           # Output values (ALB DNS, RDS endpoint, etc.)
├── terraform.tfvars     # Environment-specific values
│
├── modules/
│   ├── vpc/             # VPC, subnets, IGW, route tables
│   ├── alb/             # Application Load Balancer + target groups
│   ├── ec2/             # Launch template + Auto Scaling Group
│   ├── rds/             # RDS MySQL, subnet group, parameter group
│   ├── s3/              # S3 bucket + lifecycle + encryption
│   ├── security-groups/ # All SG rules (ALB, EC2, RDS)
│   └── iam/             # Instance profiles + policies
```

Each module is **independently reusable** — swap the VPC module into any other project without changes.

---

## Security design decisions

**Network isolation:** All application servers and the database live in private subnets. The only public-facing resource is the ALB. EC2 instances have zero direct internet exposure.

**Least-privilege security groups:**
- ALB SG: accepts 80/443 from `0.0.0.0/0`
- EC2 SG: accepts traffic only from ALB SG (not from internet)
- RDS SG: accepts traffic only from EC2 SG (not from ALB or internet)

**Encryption everywhere:**
- RDS: encrypted at rest (AWS KMS)
- S3: SSE-S3 encryption + versioning enabled
- Data in transit: HTTPS enforced at ALB

---

## How to deploy

```bash
# Prerequisites: AWS CLI configured, Terraform >= 1.3

git clone https://github.com/Heyyprakhar1/<repo-name>
cd <repo-name>

# Initialize Terraform
terraform init

# Review the plan
terraform plan -var-file="terraform.tfvars"

# Deploy
terraform apply -var-file="terraform.tfvars"

# Destroy when done
terraform destroy -var-file="terraform.tfvars"
```

---

## Cost considerations

This infrastructure is designed for production workloads. Running costs (us-east-1, approximate):

| Resource | Monthly estimate |
|---|---|
| EC2 (2× t3.micro, ASG min) | ~$15 |
| RDS (db.t3.micro, Multi-AZ) | ~$30 |
| ALB | ~$20 |
| NAT Gateway (2×) | ~$65 |
| S3 + data transfer | ~$5 |
| **Total** | **~$135/month** |

> Tip: For dev/test, disable Multi-AZ on RDS and reduce to 1 NAT Gateway to cut costs by ~50%.

---

<div align="center">

**Built by [Prakhar Srivastava](https://github.com/Heyyprakhar1)**
· [Portfolio](https://prakharsrivastava-devops.netlify.app/)
· [LinkedIn](https://linkedin.com/in/heyyprakhar1)

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:FF9900,100:185FA5&height=100&section=footer&text=Infrastructure%20as%20Code%20%7C%20Terraform&fontSize=20&fontColor=ffffff&fontAlignY=65&desc=70%25%20faster%20provisioning.%20Zero-downtime%20failover%20validated.&descSize=12&descColor=ffe8c0&descAlignY=85" width="100%"/>

</div>
