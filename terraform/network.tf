# VPC
resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "app" {
 vpc_id = aws_vpc.app.id
}

# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.app.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# セキュリティグループ
module "ssh_sg" {
  source      = "./security_group"
  name        = "ssh-sg"
  vpc_id      = aws_vpc.app.id
  port        = 22
  cidr_blocks = ["0.0.0.0/0"]
}

module "tomcat_internal_sg" {
  source      = "./security_group"
  name        = "tomcat-internal-sg"
  vpc_id      = aws_vpc.app.id
  port        = 8080
  source_security_group_id = module.http_sg.security_group_id
}

module "http_sg" {
  source      = "./security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.app.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
