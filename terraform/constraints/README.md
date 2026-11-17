# Terraform Constraints: Learn by Topic

This folder is organized as a mini lesson on Terraform constraints.

## 1. Type Basics

Terraform variables can be strongly typed. This makes modules easier to understand, safer to use, and easier to validate.

Common types:
- `string`
- `number`
- `bool`
- `list(string)`
- `map(string)`
- `object({ ... })`

Example:

```hcl
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "enable_backup" {
  type = bool
  default = true
}

variable "allowed_ports" {
  type = list(number)
  default = [22, 80, 443]
}
```

## 2. Validation

You can use a `validation` block to enforce business rules before Terraform applies configuration.

Example: only allow supported environments.

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
```

Example: validate that a CIDR block is real.

```hcl
variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}
```

## 3. Sensitive Values

Use `sensitive = true` for credentials or secrets.

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

## 4. AWS Examples

Use typed variables for AWS resources like VPCs, EC2, and RDS.

```hcl
variable "database_config" {
  type = object({
    engine            = string
    instance_class    = string
    allocated_storage = number
    backup_retention  = number
    multi_az          = bool
  })
}
```

This is especially useful when you manage infrastructure across multiple environments.

## 5. `for_each` and Maps

`for_each` works well with maps. This is a strong pattern for repeated infrastructure resources.

```hcl
variable "subnets" {
  type = map(object({
    cidr_block = string
    az        = string
  }))
}
```

Then use it like this:

```hcl
resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
}
```

## 6. Common Best Practices

- Always type module variables
- Use validation for environment and network rules
- Use `sensitive = true` for secrets
- Prefer `object` for grouped config
- Use `for_each` for shared patterns
- Keep `any` usage minimal

## 7. Recommended Folder Structure

```text
terraform/
├── constraints/
│   ├── README.md
│   ├── advanced.md
│   └── examples/
│       ├── aws_types_example.tf
│       ├── main.tf
│       └── terraform.tfvars.example
```

## 8. Summary

Terraform constraints help you define valid input, protect secrets, and standardize how modules are used. In AWS infrastructure, this helps prevent mistakes like invalid CIDR ranges, unsupported regions, and insecure database settings.

See:
- `advanced.md` for nested objects and `for_each`
- `meta-arguments/README.md` for Terraform resource meta-arguments like `count`, `for_each`, `depends_on`, `provider`, and `lifecycle`
- `lifecycle/README.md` for lifecycle safety rules such as `create_before_destroy`, `prevent_destroy`, and `ignore_changes`
- `expressions/README.md` for Terraform expressions, conditionals, loops, and built-in functions
- `dynamic-blocks/README.md` for generating repeated nested blocks with `dynamic` and `for_each`
- `examples/` for sample Terraform files
