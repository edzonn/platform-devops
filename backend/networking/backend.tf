# Configure the S3 backend for Terraform
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

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}