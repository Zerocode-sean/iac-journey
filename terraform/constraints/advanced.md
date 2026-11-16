# Terraform Constraints: Advanced Patterns

This file covers more advanced Terraform constraint patterns, including nested objects and `for_each` usage.

## 1. Nested object constraints

Nested objects are useful when a module needs a structured configuration with multiple layers.

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

  default = {
    engine = {
      name    = "mysql"
      version = "8.0"
    }
    instance = {
      class            = "db.t3.micro"
      allocated_storage = 20
      multi_az         = false
    }
    backup = {
      retention_days = 7
      enabled        = true
    }
  }
}
```

This is useful when you want to model structured configuration in a clean way.

## 2. Using nested objects in resources

```hcl
resource "aws_db_instance" "main" {
  identifier           = "demo-db"
  engine               = var.database_config.engine.name
  engine_version       = var.database_config.engine.version
  instance_class       = var.database_config.instance.class
  allocated_storage    = var.database_config.instance.allocated_storage
  multi_az             = var.database_config.instance.multi_az
  backup_retention_period = var.database_config.backup.retention_days
  skip_final_snapshot  = true
}
```

This makes the configuration easier to manage than passing lots of separate variables.

## 3. `for_each` with maps

`for_each` is commonly used to iterate over maps of items, such as subnet definitions or IAM users.

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

  tags = {
    Name = each.key
  }
}
```

This pattern is useful when you need consistent infrastructure patterns repeated by name.

## 4. `for_each` with validation

You can combine `for_each` with variable validation to ensure keys or values follow your rules.

```hcl
variable "environments" {
  type = map(object({
    cidr_block = string
    region     = string
  }))

  validation {
    condition = alltrue([
      for env_name, env in var.environments : contains(["dev", "staging", "prod"], env_name)
    ])
    error_message = "Environment names must be one of: dev, staging, prod."
  }
}
```

## 5. Validation for production environment names

A common need is to restrict environments to valid names.

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
```

This prevents typos like `production` or `PRD` from accidentally being deployed to a wrong environment.

You can also validate more strictly:

```hcl
variable "environment" {
  type = string

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "environment must be exactly dev, staging, or prod."
  }
}
```

## 6. Validation for AWS resource naming

Another common rule is to enforce naming conventions.

```hcl
variable "project_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}
```

This reduces naming issues in AWS resources.

## 7. Best practices for advanced constraints

- Use `object` for structured config instead of many loose variables
- Use `map` + `for_each` for repeated infrastructure patterns
- Validate names and allowed environments early
- Keep `sensitive` values separate from normal typed config
- Prefer narrow, explicit constraints over broad `any` types

## 8. Example: validated environment map

```hcl
variable "env_config" {
  type = map(object({
    cidr_block = string
    region     = string
  }))

  default = {
    dev = {
      cidr_block = "10.0.0.0/16"
      region     = "us-east-1"
    }
    prod = {
      cidr_block = "10.1.0.0/16"
      region     = "us-east-1"
    }
  }

  validation {
    condition = alltrue([
      for env_name, env in var.env_config : contains(["dev", "staging", "prod"], env_name)
    ])
    error_message = "Only dev, staging, and prod are allowed environment names."
  }
}
```

## 9. Summary

Advanced Terraform constraints help you:
- validate structured configuration
- enforce naming conventions
- restrict environments
- use `for_each` for reusable infrastructure patterns
- reduce mistakes before apply

For most AWS projects, the key patterns are:
- `map(object(...))` for repeated resources
- `object({...})` for grouped config blocks
- validation rules for environment names, CIDR ranges, and approved instance types
