locals {
  name   = "platform-${basename(path.cwd)}"
  region = var.aws_region

  vpc_cidr = var.vpc_cidr_block
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Name        = local.name
    PlatformPOC = "terraform-aws-vpc"
    PlatformORG = "platform"
  }
}