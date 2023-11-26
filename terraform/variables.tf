# EC2
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

variable instances {
  type = list(object({
    name = string
    subnet = string
  }))
  default = [
    {
      name = "app-server-0",
      subnet = "ap-northeast-1a"
    },
    {
      name = "app-server-1",
      subnet = "ap-northeast-1c"
    },
    {
      name = "app-server-2",
      subnet = "ap-northeast-1a"
    },
    {
      name = "app-server-3",
      subnet = "ap-northeast-1c"
    },
  ]
}

# network
variable "public_subnets" {
  type = list(object({
    az = string
    cidr = string
  }))
  default = [
    {
      az = "ap-northeast-1a",
      cidr = "10.0.10.0/24"
    },
    {
      az = "ap-northeast-1c",
      cidr = "10.0.11.0/24"
    }
  ]
}

variable "private_subnets" {
  type = list(object({
    az = string
    cidr = string
  }))
  default = [
    {
      az = "ap-northeast-1a",
      cidr = "10.0.20.0/24"
    },
    {
      az = "ap-northeast-1c",
      cidr = "10.0.21.0/24"
    }
  ]
}

# route53
variable "domain" {
  type = string
  default = null
}

# ecs
variable "image_tag" {
  type = string
  default = "330361183183.dkr.ecr.ap-northeast-1.amazonaws.com/web-demo-ecs:0.0.1-SNAPSHOT"
}
