terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "sg_suffix" {
  length = 2
}

resource "aws_security_group" "sg-1" {
  name        = "newsg-1-${random_pet.sg_suffix.id}"
  description = "Security group for example server"

  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "aneeka-kazhutha" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  key_name      = "newkey"
  associate_public_ip_address = true

  tags = {
    Name = "aneeka-kazhutha"
  }
}

output "ec2-ip" {
  value = aws_instance.aneeka-kazhutha.public_ip
}