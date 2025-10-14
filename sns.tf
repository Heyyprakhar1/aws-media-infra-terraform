# SNS Topic for upload notifications
resource "aws_sns_topic" "uploads" {
  name = "${var.environment}-upload-notifications"

  tags = {
    Name        = "${var.environment}-upload-notifications"
    Environment = var.environment
  }
}

# SNS Topic Subscription (Email)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.uploads.arn
  protocol  = "email"
  endpoint  = "srivprak0106@gmail.com" 
}