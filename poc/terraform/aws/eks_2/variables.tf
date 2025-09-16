variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "poc-pwg-cluster"
}

variable "ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = string
  }))

  default = [
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow SSH from anywhere" },
    { from_port = 80,   to_port = 80,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTP from anywhere" },
    { from_port = 0,   to_port = 0,   protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTP from anywhere" },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = ["10.11.0.0/16"], description = "Allow HTTPS from internal network" },
  ]
}

variable "egress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = string
  }))

  default = [
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow outbound SSH" },
    { from_port = 80,   to_port = 80,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow outbound HTTP" },
    { from_port = 0,   to_port = 0,   protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTP from anywhere" },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = ["10.11.0.0/16"], description = "Allow outbound HTTPS to internal network" },
  ]
}
