variable "region" {
  type    = string
  default = "ap-southeast-1"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
  default = "vpc-0bf99bf59062ade05"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default = ["subnet-092142c25cd051cff", "subnet-06abff441874d1e7e"]
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
