terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "3-tier-app-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "3-tier-app-terraform-backend"
  }
}

resource "aws_vpc" "3-tierapp-vpc" {
  cidr_block       = "10.0.0.0/24"

  tags = {
    Name = "3-tierapp-vpc"
  }
}

resource "aws_subnet" "3-tierweb-pbsb" {
  vpc_id     = aws_vpc.3-tierapp-vpc.id
  cidr_block = "10.0.0.0/25"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Name = "3-tierweb-pbsb"
  }
}

resource "aws_subnet" "3-tierapp-pvsb" {
  vpc_id     = aws_vpc.3-tierapp-vpc.id
  cidr_block = "10.0.0.85/25"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Name = "3-tierapp-pvsb"
  }
}

resource "aws_subnet" "3-tierdb-pvsb" {
  vpc_id     = aws_vpc.3-tierapp-vpc.id
  cidr_block = "10.0.0.161/25"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Name = "3-tierdb-pvsb"
  }
}

resource "aws_instance" "web-ser" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.3-tierweb-pbsb.id

  tags = {
    Name = "web-ser"
  }
}

resource "aws_instance" "app-ser" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.3-tierapp-pbsb.id

  tags = {
    Name = "app-ser"
  }
}

resource "aws_db_instance" "db-ser" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "naveen"
  password             = "nani#1208"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_internet_gateway" "3tier-app_igw" {
  vpc_id = aws_vpc.3-tierapp-vpc.id 

  tags = {
    Name = "e3tier-app-igw"
  }
}

resource "aws_nat_gateway" "3tierapp-nat_gateway" {
  allocation_id = aws_eip.tierapp_eip.id
  subnet_id     = aws_subnet.3-tierdb-pvsb.id
}

resource "aws_eip" "tierapp_eip" {
  vpc = true
}

resource "aws_autoscaling_group" "3tierapp_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier = ["3-tierweb-pbsb", "3-tierapp-pvsb"]
  health_check_type          = "EC2"
  health_check_grace_period  = 300
  force_delete               = true

  tag {
    key                 = "name"
    value               = "3tier-asg-instance"
    propagate_at_launch = true
  }
}
