variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "demo-app"
}

locals {
  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
  app_name      = "${var.project_name}-${var.environment}"
  ports         = [22, 80, 443]
  upper_names   = [for name in ["app", "db", "cache"] : upper(name)]
  valid_env     = can(regex("^(dev|staging|prod)$", var.environment))
}

output "instance_type" {
  value = local.instance_type
}

output "app_name" {
  value = local.app_name
}

output "first_port" {
  value = local.ports[0]
}

output "upper_names" {
  value = local.upper_names
}

output "environment_valid" {
  value = local.valid_env
}
