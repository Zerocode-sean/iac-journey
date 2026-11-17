resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-prod"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
}

resource "aws_db_instance" "primary" {
  identifier = "prod-db"
  engine     = "mysql"
  instance_class = "db.t3.micro"
  username   = "admin"
  password   = "change-me"
  skip_final_snapshot = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = "web-"
  image_id     = "ami-12345678"
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "main" {
  name         = "web-asg"
  max_size     = 3
  min_size     = 1

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  lifecycle {
    replace_triggered_by = [aws_launch_template.main.latest_version]
  }
}
