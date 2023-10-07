# web-demo terraform

## Getting Started
```
$ cd terraform
$ ssh-keygen -t rsa -b 4096 -f ./aws-web-demo.pem
$ terraform init
$ terraform plan -var 'domain=<your_domain>'
$ terraform apply -var 'domain=<your_domain>'
```
