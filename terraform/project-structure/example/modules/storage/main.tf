resource "aws_s3_bucket" "app_data" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-data"
  })
}
