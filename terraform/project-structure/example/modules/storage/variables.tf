variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all storage resources"
  type        = map(string)
  default     = {}
}
