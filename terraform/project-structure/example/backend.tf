terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "iac-demo/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
