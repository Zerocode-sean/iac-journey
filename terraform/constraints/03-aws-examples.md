# 03. AWS Examples With Terraform Constraints

This lesson shows how type constraints and validation are used in real AWS infrastructure code.

## Example 1: VPC CIDR validation

```hcl
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}
```

## Example 2: Allowed AWS regions

```hcl
variable "aws_region" {
  type = string
  default = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "aws_region must be a supported AWS region."
  }
}
```

## Example 3: EC2 instance restriction

```hcl
variable "instance_type" {
  type = string
  default = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "instance_type must be one of the approved instance sizes."
  }
}
```

## Example 4: Database config object

```hcl
variable "database_config" {
  type = object({
    engine            = string
    instance_class    = string
    allocated_storage = number
    backup_retention  = number
    multi_az          = bool
  })

  default = {
    engine            = "mysql"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    backup_retention  = 7
    multi_az          = false
  }
}
```

## Example 5: Security group ports

```hcl
variable "allowed_ports" {
  type = list(number)
  default = [22, 80, 443]
}
```

## Example 6: Tags map

```hcl
variable "tags" {
  type = map(string)
  default = {
    Project     = "iac-demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Summary

In AWS projects, type constraints and validation are especially helpful for managing:
- regions
- CIDR blocks
- instance types
- security group ports
- database config
- tags

These rules help you catch mistakes before provisioning resources in AWS.
