terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14.9"
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-kk"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


