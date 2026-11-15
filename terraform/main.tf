# configure provider 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "iac-journey"
  }
}

provider "aws" {
  region = var.aws_region
}

# Create S3 Bucket 
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = merge(local.common_tags, {
    Name = var.bucket_name
  })
}

# create S3 Bucket Policy
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

# create vpc 
resource "aws_vpc" "lab_vpc" {
  cidr_block = var.cidr_block

  tags = merge(local.common_tags, {
    Name = "lab-vpc"
  })
}

output "s3_bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.arn
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.lab_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.lab_vpc.cidr_block
}

output "vpc_name_tag" {
  description = "The Name tag value applied to the VPC"
  value       = aws_vpc.lab_vpc.tags["Name"]
}