terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.4"
}

provider "aws" {
  default_tags {
    tags = local.default_tags
  }

  region = var.aws_region
}

provider "aws" {
  alias = "replicated"

  default_tags {
    tags = local.default_tags
  }

  region = var.aws_replication_region
}
