variable "aws_region" {
  description = "AWS region to deploy the resources into"
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "iac-terraform-bucket-v1"
}

variable "environment" {
  description = "Environment name for the resource tags"
  type        = string
  default     = "dev"
}

