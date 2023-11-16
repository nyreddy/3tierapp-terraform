3-Tier Application Infrastructure
Overview
This project deploys a 3-tier web application infrastructure on Amazon Web Services (AWS) using Terraform. The infrastructure includes a Virtual Private Cloud (VPC) with public and private subnets, Amazon EC2 instances for web and application tiers, an RDS MySQL database in a private subnet, and associated networking components.

Infrastructure Components
VPC
The VPC is the foundation of the infrastructure, providing network isolation. It has a CIDR block of "10.0.0.0/16" and is divided into public and private subnets across multiple availability zones for high availability.

Subnets
Public Subnets (A and B): Used for web and application instances. They have CIDR blocks "10.0.1.0/24" and "10.0.3.0/24" in availability zones "us-east-1a" and "us-east-1b," respectively.
Private Subnets (A and B): Used for RDS instances. They have CIDR blocks "10.0.2.0/24" and "10.0.4.0/24" in the corresponding availability zones.
EC2 Instances
Web Server (t2.micro): Deployed in the public subnet (us-east-1a).
Application Server (t2.micro): Deployed in the public subnet (us-east-1b).
RDS Instance
Database Server (db.t3.micro): MySQL RDS instance deployed in private subnets. Allocated storage is 20 GB.
Networking Components
Internet Gateway (IGW): Attached to the VPC for enabling internet access in public subnets.
NAT Gateway: Facilitates outbound internet traffic for instances in private subnets.
Security Groups
example_sg: Security group allowing all inbound and outbound traffic on port 80 for web and application servers.
ec2_to_rds: Security group rule allowing MySQL (port 3306) traffic from EC2 instances to RDS in private subnets.
How to Use
Prerequisites
Terraform installed.
AWS credentials configured.
Deployment Steps
Clone this repository.
Navigate to the terraform directory.
Run terraform init to initialize your working directory.
Run terraform apply to apply the changes.
Terraform Commands
terraform init: Initialize the working directory.
terraform plan: Show changes before applying.
terraform apply: Apply changes to the infrastructure.
terraform destroy: Destroy the infrastructure.
Author
[Your Name]
