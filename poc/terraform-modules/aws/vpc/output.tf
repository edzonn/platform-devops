output "vpc_id" { value = aws_vpc.this.id }
output "public_subnets" { value = aws_subnet.public[*].id }
output "private_subnets" { value = aws_subnet.private[*].id }
output "db_subnets" { value = aws_subnet.db[*].id }
output "db_subnet_group" { value = aws_db_subnet_group.this.name }
output "flow_log_id" {
  value       = try(aws_flow_log.this[0].id, null)
}
output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
}
output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
}




