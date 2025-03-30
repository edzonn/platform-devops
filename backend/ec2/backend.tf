
# create ec2 instane main.terraform {
provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket         = "platform-terraform-state-201"
    key            = "networking/terraform.state"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "platform-lock-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }
}

# data "aws_kms_key" "default" {
#   key_id = "alias/aws/ebs"
# }

# output "default_kms_arn" {
#   value = data.aws_kms_key.default.arn
# }

# # create target_group

# resource "aws_lb_target_group" "platform-dev-test-tg" {
#   name     = "platform-dev-test-tg"
#   port     = 4545
#   protocol = "TCP"
#   vpc_id   = data.terraform_remote_state.module_outputs.outputs.vpc_id
#   tags = {
#     Name = "platform-dev-test-tg"
#   }
# }

# # create load balancer
