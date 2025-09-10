

# data "aws_vpc" "default" {
#   default = true
# }


# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }
# }

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "/home/adiezon/scripts/poc/terraform/aws/vpc/terraform.tfstate"
  }
}

module "eks" {
  source                        = "../../../terraform-modules/aws/eks"
  region                        = "ap-southeast-1"
  cluster_name                  = "my-eks"
  cluster_version               = "1.31"
  vpc_id                        = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids                    = data.terraform_remote_state.vpc.outputs.private_subnets
  instance_type                 = "t3.large"
  desired_capacity              = 2
  min_size                      = 1
  max_size                      = 3
  node_disk_size = 20
  additional_security_group_ids = aws_security_group.poc[*].id
  #   tags             = { Environment = "dev", Owner = "platform" }
}


provider "aws" {
  region = var.region
}

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# data "aws_eks_cluster" "this" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_id
# }



