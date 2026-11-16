# AWS Terraform Example

This example follows a module-based Terraform layout for a simple AWS environment.

## Structure

```text
example/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   └── variables.tf
│   └── prod/
│       ├── main.tf
│       └── variables.tf
└── README.md
```

## What this creates

- VPC
- public subnet
- internet gateway
- route table
- security group
- EC2 instance
- S3 bucket

## Remote state example

The `backend.tf` file shows an S3 remote backend example:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "iac-demo/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

This is a common pattern for team-based Terraform workflows.

## Notes

- Keep `dev` and `prod` separate in separate folders or workspaces
- Store state in S3 rather than locally
- Use IAM roles instead of long-lived access keys when possible
- Keep modules reusable and environment-agnostic
- Use `terraform fmt`, `terraform validate`, and `terraform plan` before apply
