# output "oidc_provider_arn" {
#   description = "ARN of the OIDC provider"
#   value       = aws_iam_openid_connect_provider.eks.arn
# }

# output "node_instance_profile_name" {
#   description = "IAM instance profile name for worker nodes"
#   value       = aws_iam_instance_profile.eks_node_instance_profile.name
# }

# output "asg_name" {
#   description = "Name of the EKS self-managed node autoscaling group"
#   value       = aws_autoscaling_group.eks_nodes.name
# }

output "additional_security_group_ids" {
  value = aws_security_group.poc[*].id
}

