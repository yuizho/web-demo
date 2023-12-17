# web-demo terraform

## Getting Started
### apply trraform configs to aws
```
$ cd terraform
$ terraform domain

# domain, image_tag variable is optional
$ terraform plan -var 'domain=<your_domain>' -var 'image_tag=xxxx.dkr.ecr.ap-northeast-1.amazonaws.com/web-demo-ecs:0.0.1-SNAPSHOT'
$ terraform apply -var 'domain=<your_domain>' -var 'image_tag=xxxx.dkr.ecr.ap-northeast-1.amazonaws.com/web-demo-ecs:0.0.1-SNAPSHOT'
```

### deploy ecs containers by ecspresso
```
$ IMAGE_TAG='xxxx.dkr.ecr.ap-northeast-1.amazonaws.com/web-demo-ecs:0.0.1-SNAPSHOT' ecspresso deploy
```
