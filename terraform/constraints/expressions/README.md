# Terraform Expressions

Terraform expressions are the language used to compute values inside variables, resource arguments, conditionals, loops, and functions. They are what make Terraform flexible enough to build dynamic infrastructure definitions.

This topic covers the most important expression patterns you will use in real Terraform code.

## What Terraform expressions are

An expression is any valid Terraform value or computation, such as:

- literals like strings, numbers, and booleans
- arithmetic like `1 + 2`
- conditionals like `var.env == "prod" ? "large" : "small"`
- collection expressions like `["a", "b", "c"]`
- template strings like `"${aws_instance.web.id}"`
- `for` expressions and `splat` expressions

Terraform expressions are used everywhere, not just in variables.

## 1. Literal values

```hcl
variable "project_name" {
  type    = string
  default = "demo-app"
}

variable "enable_backup" {
  type    = bool
  default = true
}

variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}
```

This is the simplest form of expression: a direct value.

## 2. Arithmetic and comparison expressions

```hcl
variable "instance_count" {
  type    = number
  default = 3
}

output "total_capacity" {
  value = var.instance_count * 2
}

output "is_production" {
  value = var.environment == "prod"
}
```

Common operators:

- arithmetic: `+`, `-`, `*`, `/`, `%`
- comparison: `==`, `!=`, `>`, `>=`, `<`, `<=`
- logical: `&&`, `||`, `!`

## 3. Conditional expressions

Use a conditional expression to choose one value or another.

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
}
```

This is useful when a value changes based on a condition.

## 4. Template strings

Template strings allow interpolation of values into strings.

```hcl
locals {
  bucket_name = "${var.project_name}-${var.environment}-logs"
  message     = "Deploying to ${var.environment}"
}
```

If you need a string built dynamically, this is one of the most common patterns in Terraform.

## 5. Collection expressions and indexing

```hcl
locals {
  ports = [22, 80, 443]
  first_port = local.ports[0]
  last_port = local.ports[length(local.ports) - 1]
}
```

You can also construct maps and lists directly:

```hcl
locals {
  tags = {
    Name      = "demo-app"
    ManagedBy = "terraform"
  }
}
```

## 6. `for` expressions

`for` expressions let you transform collections.

```hcl
locals {
  names = ["app", "db", "cache"]

  upper_names = [for name in local.names : upper(name)]

  subnet_map = {
    for idx, subnet in ["10.0.1.0/24", "10.0.2.0/24"] : idx => subnet
  }
}
```

Use `for` expressions when you want to map, filter, or generate values from a list or map.

## 7. Splat expressions

Splat expressions are a short way to access attributes from a list of objects.

```hcl
locals {
  instances = [
    { id = "i-111" },
    { id = "i-222" }
  ]

  ids = local.instances[*].id
}
```

This produces a list of IDs without manually iterating over the collection.

## 8. Function calls

Terraform includes many built-in functions.

```hcl
locals {
  first_name = "Alice"
  greeting   = upper(local.first_name)
  port_map   = join(",", ["80", "443"])
  has_https  = contains([80, 443], 443)
}
```

Common examples:

- `length(...)`
- `contains(...)`
- `lookup(...)`
- `join(...)`
- `merge(...)`
- `replace(...)`
- `regex(...)`
- `coalesce(...)`

## 9. `try` and `can`

Use `try` and `can` to handle optional or uncertain values safely.

```hcl
locals {
  db_endpoint = try(aws_db_instance.main.endpoint, "not-created-yet")
  valid_cidr  = can(cidrhost(var.vpc_cidr, 0))
}
```

This is especially useful when values may not exist yet or may fail validation.

## 10. `regex` and validation expressions

```hcl
variable "environment" {
  type = string

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "environment must be dev, staging, or prod."
  }
}
```

Expressions are often used together with validation to restrict bad input before apply.

## 11. `coalesce` and defaults

```hcl
locals {
  default_region = coalesce(var.aws_region, "us-east-1")
}
```

`coalesce` picks the first non-null value from a list, which is helpful for defaulting values.

## 12. Example folder

This topic is stored under its own folder so it can be taught separately from variables, constraints, and lifecycle behavior.

```text
terraform/
└── constraints/
    ├── expressions/
    │   ├── README.md
    │   └── examples/
    │       └── main.tf
```

## 13. Why expressions matter

Expressions are the glue that makes Terraform dynamic. They allow you to:

- build values from inputs
- validate configuration
- transform lists and maps
- apply conditions and defaults
- generate names and tags
- link resources together without hardcoding every value

## 14. Summary

Terraform expressions are how you turn configuration data into dynamic decisions. The most common types are:

- literals
- arithmetic and comparisons
- conditionals
- template strings
- `for` expressions
- splat expressions
- function calls
- `try` and `can`
- validation expressions

Together, these form the core of practical Terraform code.
