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
    tags = {
      Application = "aws-swan-demo"
      Environment = var.environment
    }
  }

  region = var.aws_region
}

resource "aws_s3_bucket" "test" {}
