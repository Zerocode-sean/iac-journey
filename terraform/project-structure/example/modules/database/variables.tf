variable "db_name" {
  description = "The identifier for the RDS database"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The instance type for the RDS database"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage to allocate for the RDS database"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "The type of storage to use for the RDS database"
  type        = string
  default     = "gp2"
}

variable "username" {
  description = "Database username for the admin account"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Database password. Prefer retrieving this from Secrets Manager."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_id" {
  description = "Secrets Manager secret ID containing DB credentials"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID where the DB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_ingress_cidr_blocks" {
  description = "CIDR ranges allowed to reach the DB"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "multi_az" {
  description = "Whether the DB should be deployed in multiple availability zones"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}