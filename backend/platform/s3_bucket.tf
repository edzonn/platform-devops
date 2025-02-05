
# Create an S3 bucket to store the Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  acl    = "private"

  # Versioning is recommended to keep a history of state files
  versioning {
    enabled = true
  }

  # Server-side encryption is recommended to encrypt state files
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true # Prevent accidental deletion of the bucket
  }
}

