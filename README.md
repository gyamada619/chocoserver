![chocologo](http://devopspecialist.co.uk/wp-content/uploads/2016/09/choco-logo.jpg)

# Chocoserver
This Terraform module creates a server with the recommended specs for Chocolately.Server.

### Terraform Usage

```
module "chocoserver" {
  source = "git@github.com:gyamada619/terraform-aws-chocoserver.git"
  key_name = "your-SSH-key"
  region = "us-east-1"
}
```

### Inputs

| Name | Description | Type | Default | Required |
| ------------- | ------------- | ------------- | ------------- | ------------- | 
| admin_password  | Windows Administrator password to login as.  | string | empty | yes | 
| key_name  | Name of the SSH keypair to use in AWS.  | string | empty | yes | 
| aws_region | AWS region to launch server. | string | us-east-1 | no | 
