# configure provider 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create S3 Bucket 
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
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
  region = var.aws_vpc_region[0]

  tags = {
    Name       = "lab-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


output "name" {
  value = aws_vpc.lab_vpc.name
}