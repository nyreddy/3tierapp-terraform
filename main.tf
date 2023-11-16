terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
terraform{
  backend "s3" {
    bucket         = "3-tier-app-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_statefile"
  }
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # Public subnet
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true  # Public subnet
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_launch_template" "example_launch_template" {
  name          = "example-launch-template"
  image_id      = "ami-03e0b06f01d45a4eb"
  instance_type = "t2.micro"
}
resource "aws_autoscaling_group" "example_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  health_check_type          = "EC2"
  health_check_grace_period  = 300
  force_delete               = true
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.example_launch_template.id
        version            = "$Latest"  # You can use a specific version if needed
      }

      override {
        instance_type = "t3.micro"  # Additional instance type with its weighted capacity
      }
    }

    instances_distribution {
      on_demand_allocation_strategy = "lowest-price"  # You can choose 'prioritized' or 'lowest-price'
      spot_allocation_strategy     = "lowest-price"
    }
  }

  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_db_subnet_group" "example_db_subnet_group" {
  name       = "example-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
}

resource "aws_db_instance" "example_db_instance" {
  identifier           = "example-db-instance"
  engine               = "mysql"
  allocated_storage    = 20
  instance_class       = "db.t3.micro"
  username             = "----" # give your username
  password             = "----" # give your password
  db_subnet_group_name = aws_db_subnet_group.example_db_subnet_group.name

  tags = {
    Name = "example-db-instance"
  }
}

# Security Group allowing all inbound traffic and outbound traffic on port 80
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow all inbound traffic and outbound traffic on port 80"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_eip" "lb" {
  instance = aws_instance.example_igw.id
  domain   = "vpc"
}

# NAT Gateway for public subnet
resource "aws_nat_gateway" "example" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet_a.id
}

