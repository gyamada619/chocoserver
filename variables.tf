# Set password for Administrator user.
variable "admin_password" {
  description = "Windows Administrator password to login as."
  default     = ""
}

# Give Terraform the name of the key pair to use.
# Generate a key pair using the EC2 dashboard under the "Network & Security" section.
variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = ""
}

# Tell Terraform the region you want to use. Default here is us-east-1 (Virginia).
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}
