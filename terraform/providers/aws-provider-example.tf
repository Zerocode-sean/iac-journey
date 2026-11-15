terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-provider-demo-bucket"

  tags = {
    Name        = "demo-bucket"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
