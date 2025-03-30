data "terraform_remote_state" "module_output" {
  backend = "s3"

  config = {
    bucket = var.backend_bucket
    key    = var.key_state
    region = var.aws_region
  }
}