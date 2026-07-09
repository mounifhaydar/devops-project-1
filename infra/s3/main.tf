variable "bucket_name" {}
variable "name" {}
variable "environment" {}
variable "region" {}

output "remote_state_s3_bucket_name" {
  value = aws_s3_bucket.remote_state_bucket.id
}

output "remote_state_s3_bucket_arn" {
  value = aws_s3_bucket.remote_state_bucket.arn
}

# S3 bucket for Terraform remote state
resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# Enable versioning — essential for remote state so you can recover previous states
resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_encryption" {
  bucket = aws_s3_bucket.remote_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access — state files must never be public
resource "aws_s3_bucket_public_access_block" "remote_state_public_access" {
  bucket                  = aws_s3_bucket.remote_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
