variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# variable "cluster_endpoint" {
#   description = "EKS Cluster API endpoint"
#   type        = string
# }

# variable "cluster_auth_base64" {
#   description = "Base64 encoded EKS certificate authority data"
#   type        = string
# }

# variable "cluster_service_cidr" {
#   description = "EKS Service CIDR block"
#   type        = string
# }

# variable "private_subnet_cidrs" {
#   description = "CIDR blocks for private subnets"
#   type        = list(string)
#   default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# }

