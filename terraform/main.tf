provider "aws" {
  region = "ap-northeast-1"
}

module "app_server" {
  source = "./app_server"
  instance_type = "t3.micro"
}
