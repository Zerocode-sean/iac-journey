provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_security_group" "web" {
  name   = "${var.project_name}-sg"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.project_name}-db"
  engine               = var.database_config.engine
  instance_class       = var.database_config.instance_class
  allocated_storage    = var.database_config.allocated_storage
  backup_retention_period = var.database_config.backup_retention
  multi_az              = var.database_config.multi_az
  username             = "appadmin"
  password             = var.db_password
  skip_final_snapshot  = true
}
