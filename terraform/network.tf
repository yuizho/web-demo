# VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "app_subnet_public" {
  for_each = { for i in var.public_subnets : i.az => i }
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true
  availability_zone       = each.value.az
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "app_ig" {
 vpc_id = aws_vpc.app_vpc.id
}

# ルートテーブル
resource "aws_route_table" "app_route_table_public" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_route" "app_route_public" {
  route_table_id         = aws_route_table.app_route_table_public.id
  gateway_id             = aws_internet_gateway.app_ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "app_route_table_association_public" {
  for_each = { for i in var.public_subnets : i.az => i }
  subnet_id      = aws_subnet.app_subnet_public[each.value.az].id
  route_table_id = aws_route_table.app_route_table_public.id
}

# セキュリティグループ
module "ssh_sg" {
  source      = "./security_group"
  name        = "ssh-sg"
  vpc_id      = aws_vpc.app_vpc.id
  port        = 22
  cidr_blocks = ["0.0.0.0/0"]
}

module "tomcat_internal_sg" {
  source      = "./security_group"
  name        = "tomcat-internal-sg"
  vpc_id      = aws_vpc.app_vpc.id
  port        = 8080
  source_security_group_id = module.alb_sg.security_group_id
}

module "alb_sg" {
  source      = "./security_group"
  name        = "alb-sg"
  vpc_id      = aws_vpc.app_vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
