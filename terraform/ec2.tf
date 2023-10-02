locals {
  instance_ami = "ami-0f221f1525c20b777"
}

resource "aws_key_pair" "app_server_ssh_public_key" {
  key_name   = "app_server_ssh_public_key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server_ec2" {
  ami           = local.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.app_server_ssh_public_key.id
  vpc_security_group_ids = [aws_security_group.app_server_ec2.id]

  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "app_server_ec2" {
  name = "app_server_ec2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
