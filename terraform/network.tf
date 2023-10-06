# VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "app_subnet_public" {
  count = 2
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = count.index % 2 == 0 ? "ap-northeast-1a" : "ap-northeast-1c"
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
  count = 2
  subnet_id      = aws_subnet.app_subnet_public[count.index].id
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
  source_security_group_id = module.http_sg.security_group_id
}

module "http_sg" {
  source      = "./security_group"
  name        = "http-sg"
  vpc_id      = aws_vpc.app_vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
