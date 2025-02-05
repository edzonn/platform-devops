variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  default     = ""
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "private_subnet_names" {
  description = "The names of the private subnets"
  type        = list(string)
}

variable "public_subnet_names" {
  description = "The names of the public subnets"
  type        = list(string)
}

variable "database_subnet_names" {
  description = "The names of the database subnets"
  type        = list(string)
}

variable "intra_subnet_names" {
  description = "The names of the intra subnets"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
}


# variable "from_port" {
#   description = "The start port for the rule"
#   type        = number
# }

# variable "to_port" {
#   description = "The end port for the rule"
#   type        = number
# }
# variable "protocol" {
#   description = "The protocol for the rule"
#   type        = string
# }
# variable "cidr_blocks" {
#   description = "The CIDR blocks to allow traffic from"
#   type        = list(string)
# }
# variable "description" {
#   description = "The description of the rule"
#   type        = string
# }
# variable "security_groups" {
#   description = "The security groups to allow traffic from"
#   type        = list(string)
# }
# variable "egress_rules" {
#   description = "The egress rules for the security group"
#   type        = list(map(string))
# }