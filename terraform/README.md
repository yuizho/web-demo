# web-demo terraform

## Getting Started
```
$ cd terraform
$ ssh-keygen -t rsa -b 4096 -f ./aws-web-demo.pem
$ terraform init
$ terraform plan -var 'public_key_path=./aws-web-demo.pem.pub'
```
