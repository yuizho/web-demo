variable "instance_type" {}

locals {
  instance_ami = "ami-08e19d3f2c031d439"
}

resource "aws_instance" "app_server_ec2" {
  ami           = local.instance_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_server_ec2.id]

  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "app_server_ec2" {
  name = "app_server_ec2"

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
