# Create this new file: dynamodb.tf
resource "aws_dynamodb_table" "media_metadata" {
  name           = "${var.environment}-media-metadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "media_id"
  range_key      = "upload_date"

  attribute {
    name = "media_id"
    type = "S"
  }

  attribute {
    name = "upload_date"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-media-metadata"
    Environment = var.environment
  }
}