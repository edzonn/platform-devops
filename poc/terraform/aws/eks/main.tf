

module "eks" {
  source           = "../../terraform-modules/aws/eks"
  region           = "ap-southeast-1"
  cluster_name     = "my-eks"
  cluster_version  = "1.31"
  vpc_id           = "vpc-0bf99bf59062ade05"
  subnet_ids       = ["subnet-092142c25cd051cff", "subnet-06abff441874d1e7e"]
  instance_type    = "t3.large"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
#   tags             = { Environment = "dev", Owner = "platform" }
}


provider "aws" {
  region = var.region
}



