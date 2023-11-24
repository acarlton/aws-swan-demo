data "aws_iam_policy_document" "kms_primary_default" {
  policy_id = "key-default-1"

  # This statement is a copy of the default statement,
  #  so as to not lose access to the key.
  statement {
    actions = ["kms:*"]
    effect  = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]
    sid       = "Enable IAM User Permissions"
  }

  # Grant access to encrypt the hello-world CloudWatch log group
  #  https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    effect = "Allow"
    principals {
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
      type        = "Service"
    }
    resources = ["*"]
    condition {
      test = "ArnEquals"
      # Interpolate this (for now) due to dependency cycle when referencing
      values   = ["arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:/ecs/${local.namespace}/hello-world"]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
}

resource "aws_kms_key" "primary" {
  description         = "A custom, multi-region encryption key for securing data globally"
  enable_key_rotation = true
  multi_region        = true
  policy              = data.aws_iam_policy_document.kms_primary_default.json
}

resource "aws_kms_alias" "primary" {
  name          = "alias/${local.namespace}"
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

  name          = "alias/${local.namespace}"
  target_key_id = aws_kms_replica_key.replicated.key_id
}
