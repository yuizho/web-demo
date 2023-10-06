locals {
  instance_ami = "ami-0901f015a3d675190"
}

resource "aws_key_pair" "app_server_ssh_public_key" {
  key_name   = "app_server_ssh_public_key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server_ec2" {
  count = 4

  ami           = local.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.app_server_ssh_public_key.id
  vpc_security_group_ids = [
    module.ssh_sg.security_group_id,
    module.tomcat_internal_sg.security_group_id
  ]
  subnet_id = aws_subnet.app_subnet_public[count.index % 2 == 0 ? 0 : 1].id

  user_data = <<-EOF
    #!/bin/bash
  EOF

  tags = {
    Name = "app-server-${count.index}"
  }
}
