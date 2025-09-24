
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_node_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_autoscaling_group.eks_nodes
  ]
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = "1.33"
  

  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
    security_group_ids = [aws_security_group.poc.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy,
                 aws_iam_role.eks_node_role]

    provisioner "local-exec" {
        command = "aws eks update-kubeconfig --name ${self.name} --region ${var.region}"
    }
}

# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name  = aws_eks_cluster.eks_cluster.name
#   addon_name    = "aws-ebs-csi-driver"
#   addon_version = "v1.37.0-eksbuild.1" 
#   resolve_conflicts = "OVERWRITE"
#   service_account_role_arn = aws_iam_role.eks_node_role.arn
#   depends_on = [aws_eks_cluster.eks_cluster]
# }
  
