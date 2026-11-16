# 02. Validation in Terraform

Validation blocks let you define rules for input values before Terraform tries to apply the configuration.

## Why validation matters

Validation helps prevent mistakes like:
- unsupported AWS regions
- invalid CIDR blocks
- wrong environment names
- invalid instance sizes

## Basic validation example

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
```

## Validation for CIDR blocks

```hcl
variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}
```

## Validation for AWS regions

```hcl
variable "aws_region" {
  type = string

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "aws_region must be one of the allowed AWS regions."
  }
}
```

## Validation for naming rules

```hcl
variable "project_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}
```

## Validation and `for_each`

You can also validate maps used with `for_each`.

```hcl
variable "env_config" {
  type = map(object({
    cidr_block = string
    region     = string
  }))

  validation {
    condition = alltrue([
      for env_name, env in var.env_config : contains(["dev", "staging", "prod"], env_name)
    ])
    error_message = "Environment names must be dev, staging, or prod."
  }
}
```

## Best practice

Use validation for rules that are important to the team and should fail early before infrastructure is created.

## Summary

Validation is the second layer of safety in Terraform after type constraints. It catches bad values before they reach AWS.
