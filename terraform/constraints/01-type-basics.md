# 01. Type Basics in Terraform

Terraform variables can be strongly typed. This helps make your infrastructure code predictable and safer.

## Common Terraform types

- `string`
- `number`
- `bool`
- `list(type)`
- `map(type)`
- `object({ ... })`
- `tuple([...])`
- `set(type)`

## Basic examples

### String

```hcl
variable "project_name" {
  type = string
  default = "iac-demo"
}
```

### Number

```hcl
variable "db_size_gb" {
  type = number
  default = 20
}
```

### Boolean

```hcl
variable "enable_backup" {
  type = bool
  default = true
}
```

### List

```hcl
variable "allowed_ports" {
  type = list(number)
  default = [22, 80, 443]
}
```

### Map

```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "iac-demo"
  }
}
```

### Object

```hcl
variable "database_config" {
  type = object({
    engine           = string
    instance_class   = string
    allocated_storage = number
  })

  default = {
    engine            = "mysql"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
  }
}
```

## Why type constraints matter

Type constraints help you:
- stop invalid input early
- make modules easy to reuse
- improve readability
- reduce deployment mistakes

## Best practice

Always type variables in modules when possible. This is especially useful in AWS projects where values like `aws_region`, `instance_type`, and `vpc_cidr` need to be predictable.

## Example AWS usage

```hcl
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
```

## Summary

Type constraints are the foundation of safe Terraform variable design. They are the first layer of validation before you even deploy resources.
