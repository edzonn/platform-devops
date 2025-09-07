
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}

output "node_role_name" {
  value = aws_iam_role.node.name
}

output "node_instance_profile_name" {
  value = aws_iam_instance_profile.node.name
}

output "asg_name" {
  value = aws_autoscaling_group.nodes.name
}

output "vpc_id" {
  value = var.vpc_id
}