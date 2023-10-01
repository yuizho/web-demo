provider "aws" {
  region = "ap-northeast-1"
}

variable "public_key_path" {}

module "app_server" {
  source = "./app_server"
  instance_type = "t3.micro"
  public_key_path = var.public_key_path
}
