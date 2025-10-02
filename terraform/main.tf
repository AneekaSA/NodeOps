# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and HTTP outbound traffic"
  tags = {
    Name = "allow_ssh"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  }


resource "aws_instance" "nodeops" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t2.micro"
  key_name = "newest-key"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "nodeops"
  }
}

output "public_ip" {
  value = aws_instance.nodeops.public_ip
}
