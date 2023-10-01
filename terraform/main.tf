locals {
  instance_ami = "ami-08e19d3f2c031d439"
  instance_type = "t2.micro"
}

resource "aws_instance" "app_server_ec2" {
  ami           = local.instance_ami
  instance_type = local.instance_type

  tags = {
    Name = "example"
  }
}
