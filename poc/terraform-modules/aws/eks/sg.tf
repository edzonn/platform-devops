
resource "aws_security_group" "poc-1" {
  name = "dynamic_block_poc"
  vpc_id =  data.terraform_remote_state.vpc.outputs.vpc_id
  description = "Additional security group with dynamic blocks"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks   = try(ingress.value.cidr_blocks, null)
      security_groups = try(ingress.value.security_groups, null)
      description = ingress.value.description
    }
  }

    dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks   = try(egress.value.cidr_blocks, null)
      security_groups = try(egress.value.security_groups, null)
      description = egress.value.description
    }
  }
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
    { from_port = -1,   to_port = -1,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow outbound HTTP" },
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
    { from_port = -1,   to_port = -1,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow outbound HTTP" },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = ["10.11.0.0/16"], description = "Allow outbound HTTPS to internal network" },
  ]
}
