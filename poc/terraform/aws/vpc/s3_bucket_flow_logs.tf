resource "aws_s3_bucket" "vpc_logs" {
  bucket        = "poc-vpc-flow-logs-${var.region}-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name        = "poc-vpc-flow-logs"
    Environment = "poc"
  }
}

resource "aws_s3_bucket_versioning" "vpc_logs" {
  bucket = aws_s3_bucket.vpc_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_logs" {
  bucket = aws_s3_bucket.vpc_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
