# module "security_group" {
#   source = "/mnt/d/devops-poc/backend/networking/modules/security_group"

#   name        = var.name
#   description = var.description
#   vpc_id      = var.vpc_id

#   from_port   = var.from_port
#   to_port     = var.to_port
#   protocol    = var.protocol
#   cidr_blocks = var.cidr_blocks

#   egress_from_port   = var.egress_from_port
#   egress_to_port     = var.egress_to_port
#   egress_protocol    = var.egress_protocol
#   egress_cidr_blocks = var.egress_cidr_blocks

#   tags = local.tags
# }