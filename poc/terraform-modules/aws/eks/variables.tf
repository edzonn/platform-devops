
variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster and nodes will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS control plane and nodes"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "ASG min size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "ASG max size"
  type        = number
  default     = 3
}

variable "node_disk_size" {
  description = "Root EBS volume size in GiB for nodes"
  type        = number
  default     = 20
}

variable "kms_key_id" {
  description = "Optional custom KMS Key ID/ARN for EBS encryption. If null, use alias/aws/ebs"
  type        = string
  default     = null
}

variable "create_aws_auth" {
  description = "Whether to create the aws-auth ConfigMap inside the cluster"
  type        = bool
  default     = true
}

variable "additional_map_roles" {
  description = "Additional roles to add to aws-auth (list of objects with rolearn, username, groups)"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "List of extra security groups to attach to the worker nodes"
  default     = []
}