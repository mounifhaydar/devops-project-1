variable "bucket_name" {}
variable "name" {}
variable "environment" {}
variable "region" {}

output "remote_state_s3_bucket_name" {
  value = data.aws_s3_bucket.remote_state_bucket.id
}

output "remote_state_s3_bucket_arn" {
  value = data.aws_s3_bucket.remote_state_bucket.arn
}

# S3 bucket for Terraform remote state — created separately (infra/create-s3-bucket)
data "aws_s3_bucket" "remote_state_bucket" {
  bucket = var.bucket_name
}

# Enable versioning — essential for remote state so you can recover previous states
resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = data.aws_s3_bucket.remote_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_encryption" {
  bucket = data.aws_s3_bucket.remote_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access — state files must never be public
resource "aws_s3_bucket_public_access_block" "remote_state_public_access" {
  bucket                  = data.aws_s3_bucket.remote_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Allow the current AWS account to use the bucket as Terraform remote state storage.
# This is intentionally broad for the backend bucket and is suitable for CI/CD
# credentials that need to read/write the state file.
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "remote_state_policy" {
  bucket = data.aws_s3_bucket.remote_state_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "TerraformStateAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          data.aws_s3_bucket.remote_state_bucket.arn,
          "${data.aws_s3_bucket.remote_state_bucket.arn}/*"
        ]
      }
    ]
  })
}
