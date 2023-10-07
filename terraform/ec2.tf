resource "aws_key_pair" "app_server_ssh_public_key" {
  key_name   = "app_server_ssh_public_key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server_ec2" {
  for_each = { for i in var.instances : i.name => i }

  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.app_server_ssh_public_key.id
  vpc_security_group_ids = [
    module.ssh_sg.security_group_id,
    module.tomcat_internal_sg.security_group_id
  ]
  subnet_id = aws_subnet.app_subnet_public[each.value.subnet].id

  user_data = <<-EOF
    #!/bin/bash
  EOF

  tags = {
    Name = each.value.name
  }
}
