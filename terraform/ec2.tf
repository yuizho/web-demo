# EC2
resource "aws_instance" "app_server_ec2" {
  for_each = { for i in var.instances : i.name => i }

  ami           = var.instance_ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_for_ssm.name
  vpc_security_group_ids = [
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

# Session Manager
data "aws_iam_policy_document" "ec2_for_ssm" {
  source_policy_documents = [data.aws_iam_policy.ec2_for_ssm.policy]

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "kms:Decrypt",
    ]
  }
}

data "aws_iam_policy" "ec2_for_ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "ec2_for_ssm_role" {
  source = "./iam_role"
  name   = "ec2-for-ssm"
  // 信頼ポリシーに「ec2.amazonaws.com」を指定し、このIAMロールをEC2インスタンスで使うことを宣言する
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.ec2_for_ssm.json
}

resource "aws_iam_instance_profile" "ec2_for_ssm" {
  name = "ec2-for-ssm"
  role = module.ec2_for_ssm_role.iam_role_name
}

# log config of Session Manager
resource "aws_cloudwatch_log_group" "ec2_ssm_operation" {
  name              = "/ec2-ssm-operation"
  retention_in_days = 180
}

output "operation_instance_id" {
  value = { for i in aws_instance.app_server_ec2 : i.tags.Name => i.id }
}
