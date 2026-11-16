module "networking" {
  source = "../../modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  common_tags        = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.security_group_id
  common_tags       = local.common_tags
}

module "storage" {
  source = "../../modules/storage"

  project_name = var.project_name
  environment  = var.environment
  bucket_name  = var.bucket_name
  common_tags  = local.common_tags
}

module "database" {
  source = "../../modules/database"

  db_name             = var.db_name
  db_instance_class   = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  storage_type        = var.db_storage_type
  username            = var.db_username
  password            = var.db_password
  security_group_id   = module.networking.security_group_id
  secret_id           = var.db_secret_id
  ssm_parameter_name = var.db_ssm_parameter_name
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
