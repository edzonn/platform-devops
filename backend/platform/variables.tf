variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "terraform_state_key" {
  description = "The key for the Terraform state file in S3"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
}
