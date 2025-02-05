locals {
  name   = "platform-${basename(path.cwd)}"
  region = var.aws_region
  tags = {
    Name        = local.name
    PlatformPOC = var.platform_poc
    PlatformORG = var.platform_name
  }

  cluster_version = var.cluster_version
}