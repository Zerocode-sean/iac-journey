# 04. Advanced Terraform Patterns

This lesson covers more advanced Terraform constraint patterns, including nested objects and `for_each`.

## Nested objects

Nested objects are useful when configuration is structured and grouped together.

```hcl
variable "database_config" {
  type = object({
    engine = object({
      name    = string
      version = string
    })
    instance = object({
      class            = string
      allocated_storage = number
      multi_az         = bool
    })
    backup = object({
      retention_days = number
      enabled        = bool
    })
  })
}
```

## `for_each` with maps

`for_each` is commonly used when you have multiple similar resources, such as subnets or IAM users.

```hcl
variable "subnets" {
  type = map(object({
    cidr_block = string
    az        = string
  }))

  default = {
    app = {
      cidr_block = "10.0.1.0/24"
      az        = "us-east-1a"
    }
    db = {
      cidr_block = "10.0.2.0/24"
      az        = "us-east-1b"
    }
  }
}

resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
}
```

## Production environment validation

This is a common pattern in real projects.

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
```

You can also use a regex check:

```hcl
variable "environment" {
  type = string

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "environment must be exactly dev, staging, or prod."
  }
}
```

## Best practices for advanced patterns

- Use `object` for grouped config values
- Use `map(object(...))` with `for_each` for repeated resources
- Validate environment names early
- Keep secrets separate from typed config
- Avoid unnecessary broad types like `any`

## Summary

Advanced Terraform constraints let you model real-world AWS infrastructure more cleanly. They help you structure configuration and enforce rules before deployment.
