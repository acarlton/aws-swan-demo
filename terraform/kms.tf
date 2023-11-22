resource "aws_kms_key" "primary" {
  description         = "A custom, multi-region encryption key for securing data globally"
  enable_key_rotation = true
  multi_region        = true
}

resource "aws_kms_alias" "primary" {
  name = "alias/${local.namespace}"
  target_key_id = aws_kms_key.primary.key_id
}

# Replicated KMS key
#
# TODO: support taking a list of replicated regions?
resource "aws_kms_replica_key" "replicated" {
  provider = aws.replicated

  description     = "Multi-region replica key"
  primary_key_arn = aws_kms_key.primary.arn
}

resource "aws_kms_alias" "replicated" {
  provider = aws.replicated

  name = "alias/${local.namespace}"
  target_key_id = aws_kms_replica_key.replicated.key_id
}
