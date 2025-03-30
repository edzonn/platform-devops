
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.13.1"
  cluster_name    = "${var.cluster_name}-${var.test_name}"
  cluster_version = var.cluster_version
  iam_role_name   = "eks-node-group-role"
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true


  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = data.terraform_remote_state.module_output.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.module_output.outputs.private_subnets
  control_plane_subnet_ids = data.terraform_remote_state.module_output.outputs.intra_subnets

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = var.ami_type
      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      taints = {
        addons = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        },
      }
    }
  }

  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })

  tags = local.tags
}
