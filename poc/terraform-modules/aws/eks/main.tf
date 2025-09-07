

# Use default EBS alias unless caller provided a key
locals {
  effective_kms_key_id = var.kms_key_id != null ? var.kms_key_id : try(data.aws_ebs_default_kms_key.current.key_arn, "alias/aws/ebs")
}

# SSM parameter for EKS Optimized AMI (AL2023 x86_64 standard)
data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

# EKS cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = merge(var.tags, { VPC = var.vpc_id })

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# Node role + instance profile
resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.cluster_name}-node-instance-profile"
  role = aws_iam_role.node.name
  tags = var.tags
}

# Optional: aws-auth ConfigMap (requires kubernetes provider to be configured in the ROOT module)
resource "kubernetes_config_map" "aws_auth" {
  count = var.create_aws_auth ? 1 : 0

  metadata { 
    name = "aws-auth" 
    namespace = "kube-system" 
    }

  data = {
    mapRoles = yamlencode(concat([
      {
        rolearn  = aws_iam_role.node.arn,
        username = "system:node:{{EC2PrivateDNSName}}",
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ], var.additional_map_roles))
  }

  depends_on = [aws_eks_cluster.this, aws_autoscaling_group.nodes]
}

