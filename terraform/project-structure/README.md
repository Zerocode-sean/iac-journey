# Terraform Project Structure and Best Practices

This folder captures a recommended structure for Terraform projects and the best practices to keep infrastructure easy to maintain, secure, and scalable.

## Recommended Project Layout

```text
terraform/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── backend.tf
├── terraform.tfvars
├── terraform.tfvars.example
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security-group/
│       ├── main.tf
│       └── variables.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── README.md
│   ├── staging/
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       └── terraform.tfvars
└── .gitignore
```

## Purpose of Each File

- `main.tf` — root module composition and main resources
- `variables.tf` — input variables for the project
- `outputs.tf` — outputs exposed to users or other modules
- `providers.tf` — provider configuration
- `versions.tf` — Terraform and provider version constraints
- `backend.tf` — remote state backend configuration
- `terraform.tfvars` — environment values for local use
- `modules/` — reusable infrastructure components
- `environments/` — environment-specific deployment entry points

## Best Practices

### 1. Separate environments
Keep `dev`, `staging`, and `prod` isolated. Each environment should have its own state file and variable values.

Benefits:
- reduces risk
- avoids accidental production changes
- makes testing safer

### 2. Use a remote backend
Store Terraform state in a remote backend such as:
- S3 for state storage
- DynamoDB for locking

This prevents state corruption and improves team collaboration.

### 3. Use modules for reuse
Break infrastructure into modules such as:
- networking
- security groups
- EC2
- databases
- IAM

This makes infrastructure easier to maintain and reduces duplication.

### 4. Keep root module small
The root module should mainly call child modules and wire variables together.

Avoid putting all infrastructure logic directly in the root module for large projects.

### 5. Use version constraints
Pin Terraform and provider versions to avoid surprises from upstream breaking changes.

Example:

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### 6. Keep secrets out of code
Never commit secrets directly.

Use:
- environment variables
- AWS Secrets Manager
- SSM Parameter Store
- CI/CD secret variables

### 7. Use variables and tfvars files
Keep reusable inputs in `variables.tf` and environment-specific values in `*.tfvars` files.

Example:

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

### 8. Validate and format regularly
Run these commands often:

```bash
terraform fmt
terraform validate
terraform plan
```

This helps catch syntax problems and configuration drift early.

### 9. Tag resources consistently
Use standard tags for:
- environment
- project name
- owner
- cost center
- application name

### 10. Use IAM least privilege
Give only the permissions required for Terraform and workloads to run.

Avoid broad permissions such as `AdministratorAccess` unless absolutely necessary.

## Example Simple Structure

```text
project/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── backend.tf
├── terraform.tfvars
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## Team Guidance

- Keep naming conventions consistent across all modules
- Write clear variable descriptions
- Document module purpose and usage in a README
- Review plans before applying changes to production
- Use CI/CD to enforce validation before deployment

## Summary

A well-structured Terraform project is easier to scale, safer to operate, and simpler to troubleshoot. The biggest principles are:

- keep environments separated
- use modules for reuse
- store state remotely
- protect secrets
- validate often
- keep the codebase readable and maintainable
