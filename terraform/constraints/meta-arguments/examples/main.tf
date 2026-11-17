provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  count = 2

  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-${count.index}"
  }
}

resource "aws_s3_bucket" "logs" {
  for_each = {
    app  = "app-logs-bucket"
    data = "data-logs-bucket"
  }

  bucket = each.value
}

resource "aws_db_instance" "database" {
  identifier             = "demo-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "change-me"
  skip_final_snapshot    = true
  allocated_storage      = 20
  backup_retention_period = 7
}

resource "aws_instance" "app" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  depends_on = [aws_db_instance.database]

  lifecycle {
    create_before_destroy = true
  }
}
