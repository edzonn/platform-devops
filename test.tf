# variable "ingress_rules" {
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     security_group_id = optional(list(string), [])
    
#   }))
#   default = [
#     { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
#     { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
#     { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.11.0.0/16"] },
#     { from_port = 8080, to_port = 8080, protocol = "tcp", security_group_id = ["sg-12345678"] }
#   ]
# }
# resource "aws_security_group" "example" {
#   name = "dynamic_block_example"
#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#       security_group_id = lookup(ingress.value, "security_group_id", null)
#     }
#   }
# }

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

  default = [
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 80,   to_port = 80,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443,  to_port = 443,  protocol = "tcp", cidr_blocks = ["10.11.0.0/16"] },
    { from_port = 8080, to_port = 8080, protocol = "tcp", security_groups = ["sg-12345678"] }
  ]
}

resource "aws_security_group" "example" {
  name = "dynamic_block_example"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks   = try(ingress.value.cidr_blocks, null)
      security_groups = try(ingress.value.security_groups, null)
    }
  }
}
