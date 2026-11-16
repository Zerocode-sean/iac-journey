variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "aws_region must be one of the supported AWS regions."
  }
}

variable "project_name" {
  description = "Project name used in naming and tags"
  type        = string
  default     = "iac-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "tags" {
  description = "Map of tags applied to AWS resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "iac-demo"
    ManagedBy   = "Terraform"
  }
}

variable "allowed_ports" {
  description = "Ports allowed by the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "database_config" {
  description = "Structured database configuration"
  type = object({
    engine            = string
    instance_class    = string
    allocated_storage = number
    backup_retention  = number
    multi_az          = bool
  })

  default = {
    engine            = "mysql"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    backup_retention  = 7
    multi_az          = false
  }
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
