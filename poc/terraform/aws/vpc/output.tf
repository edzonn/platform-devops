# output "vpc_cidr_block" {
#   value       = aws_vpc.this.cidr_block
# }

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
