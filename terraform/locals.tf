locals {
  default_tags = {
    Application = "aws-swan-demo"
    Environment = var.environment
  }
  namespace = "aws-swan-demo-${var.environment}"
}
