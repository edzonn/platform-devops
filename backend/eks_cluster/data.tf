# data "aws_availability_zones" "available" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "terraform_remote_state" "module_output" {
  backend = "s3"

  config = {
    bucket = var.backend_bucket
    key    = var.key_state
    region = var.aws_region
  }
}