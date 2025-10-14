# S3 Bucket for media storage
resource "aws_s3_bucket" "media" {
  bucket = "${var.environment}-media-app-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.environment}-media-bucket"
    Environment = var.environment
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "media" {
  bucket = aws_s3_bucket.media.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "media" {
  bucket = aws_s3_bucket.media.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Lifecycle Policy (Archive to Glacier after 2 years) - FIXED
resource "aws_s3_bucket_lifecycle_configuration" "media" {
  bucket = aws_s3_bucket.media.id

  rule {
    id     = "archive-to-glacier"
    status = "Enabled"

    # FIX: Add filter to specify which objects
    filter {
      prefix = ""  # Applies to all objects
    }

    transition {
      days          = 730 # 2 years
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 730
      storage_class   = "GLACIER"
    }
  }
}

# S3 Block Public Access
resource "aws_s3_bucket_public_access_block" "media" {
  bucket = aws_s3_bucket.media.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}