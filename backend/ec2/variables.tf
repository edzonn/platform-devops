variable "allowed_ports" {
  type    = list(number)
  default = [80, 443, 22]
}


variable "backend_bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "key_state" {
  description = "The key of the S3 bucket"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}
