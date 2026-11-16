variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "iac-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "bucket_name" {
  description = "Unique S3 bucket name"
  type        = string
  default     = "iac-demo-prod-data-bucket"
}

variable "db_name" {
  description = "Database identifier"
  type        = string
  default     = "iac-demo-prod-db"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type for the database"
  type        = string
  default     = "gp2"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "Database password. Prefer storing this in Secrets Manager or a local secret file that is gitignored."
  type        = string
  default     = null
  sensitive   = true
}

variable "db_secret_id" {
  description = "Secrets Manager secret ID for database credentials"
  type        = string
  default     = ""
}

variable "db_ssm_parameter_name" {
  description = "SSM parameter name for the database password"
  type        = string
  default     = ""
}
