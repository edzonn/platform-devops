terraform {
  backend "s3" {
    bucket         = "platform-terraform-state-201"
    key            = "eks/terraform.state"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "platform-lock-table"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.30"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = local.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}
