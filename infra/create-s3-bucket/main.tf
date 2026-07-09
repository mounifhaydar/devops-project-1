terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.53.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# Values from devops-project-1/infra/terraform.tfvars
locals {
  bucket_name = "dev-proj-1-remote-state-bucket"
  name        = "environment"
  environment = "dev-1"
}

# S3 bucket for Terraform remote state
resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.name
    Environment = local.environment
  }
}

# Versioning — essential for state recovery
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.remote_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# AES256 encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.remote_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block ALL public access — state files must never be public
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.remote_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.remote_state_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.remote_state_bucket.arn
}
