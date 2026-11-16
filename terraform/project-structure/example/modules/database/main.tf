data "aws_secretsmanager_secret_version" "db" {
  count     = var.secret_id != "" ? 1 : 0
  secret_id = var.secret_id
}

locals {
  secret_value = length(data.aws_secretsmanager_secret_version.db) > 0 ? jsondecode(data.aws_secretsmanager_secret_version.db[0].secret_string) : {}
  resolved_username = var.username != "" ? var.username : try(local.secret_value["username"], "admin")
  resolved_password = (
    var.password != null && var.password != "" ? var.password : try(local.secret_value["password"], null)
  )
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.db_name}-db-sg"
  description = "Security group for the database"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-db-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier              = var.db_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  username                = local.resolved_username
  password                = local.resolved_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  apply_immediately       = true
}