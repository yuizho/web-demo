variable "public_key_path" {
  type = string
  default = "aws-web-demo.pem.pub"
}

variable "instance_ami" {
  type = string
  default = "ami-0901f015a3d675190"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}
