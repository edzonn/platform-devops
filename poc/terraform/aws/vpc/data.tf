data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_security_group" "default" {

  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

# data "aws_network_interface" "alb_eni" {
#   count = length(module.vpc.private_subnets)

#   filter {
#     name   = "subnet-id"
#     values = [module.vpc.private_subnets[count.index]]
#   }

#   filter {
#     name   = "group-id"
#     values = [data.aws_security_group.default.id]
#   }
# }

