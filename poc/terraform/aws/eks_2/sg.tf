
resource "aws_security_group" "poc" {
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