module "vpc" {
  source                 = "../../../terraform-modules/aws/vpc"
  name                   = "poc"
  region                 = var.region
  cluster_name           = "poc-cluster"
  vpc_cidr               = "10.22.0.0/16"
  public_subnet_cidr     = ["10.22.1.0/24", "10.22.2.0/24"]
  private_subnet_cidr    = ["10.22.11.0/24", "10.22.12.0/24"]
  private_db_subnet_cidr = ["10.22.21.0/24", "10.22.22.0/24"]
  availability_zones     = ["ap-southeast-1a", "ap-southeast-1b"]
  enable_nat_gateway     = true
  enable_flow_logs       = true
  #   flow_logs_destination_type = "cloud-watch-logs"
  #   flow_logs_iam_role_arn     = aws_iam_role.vpc_flow_logs.arn
  flow_logs_destination_type = "s3"
  flow_logs_s3_bucket_arn    = aws_s3_bucket.vpc_logs.arn

  tags = {
    Environment = "poc"
    Owner       = "devops"
  }
}

module "endpoints" {
  source          = "../../../terraform-modules/aws/vpc_endpoints"
  name            = "poc"
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  endpoint_sg_ids = [aws_security_group.vpc_endpoints.id]

  # You can override defaults if needed
  interface_endpoints = {
    "ecr.api" = "ECR API"
    "ecr.dkr" = "ECR Docker"
    "ecs"     = "ECS"
    "eks"     = "EKS"
  }
  gateway_endpoints = {
    "s3" = "S3"
  }

  route_table_ids = module.vpc.private_route_table_ids

  tags = {
    Environment = "poc"
  }
  depends_on = [module.vpc]
}
