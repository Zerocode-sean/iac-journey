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

variable "aws_vpc_region" {
  description = "AWS region to deploy the VPC into"
  type        = list(string)
  default     = ["us-west-2"]
}

variable "cidr_block" {
  description = "Our isolated virtual private network"
  type = string 
  default = "192.168.0.0/16"
}

# Variable for the subnet
variable "subnet" {
  description = "The subnet to deploy the resources into"
  type = string
  default = "192.168.1.0/24"
}