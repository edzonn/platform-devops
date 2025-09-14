data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

data "aws_ami" "amazon_eks" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-arm64-standard-1.33-*"]
  }

}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_ebs_default_kms_key" "current" {}

data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.eks_cluster.name
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "//home/adiezon/scripts/platform-devops/poc/terraform/aws/vpc/terraform.tfstate"
  }
}
