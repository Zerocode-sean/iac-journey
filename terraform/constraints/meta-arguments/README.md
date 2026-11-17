# Terraform Meta-Arguments

Terraform meta-arguments are special arguments that are not part of a resource's schema, but they change how Terraform manages that resource. They help with duplication, dependency ordering, provider selection, and lifecycle behavior.

These are sometimes called Terraform resource-level arguments because they apply to the resource block itself rather than describing the resource configuration.

## What they are

Meta-arguments are used to control Terraform behavior, especially when creating resources that need to be repeated, depend on other resources, or follow lifecycle rules.

The most commonly used meta-arguments are:

- `count`
- `for_each`
- `depends_on`
- `provider`
- `lifecycle`

## 1. `count`

Use `count` when you want to create multiple identical resources.

```hcl
resource "aws_instance" "web" {
  count = 3

  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-${count.index}"
  }
}
```

`count.index` gives each instance a zero-based index, which is useful for naming or tagging.

## 2. `for_each`

Use `for_each` when you want to create one resource per item in a map or set.

```hcl
variable "team_members" {
  type = map(string)

  default = {
    alice = "dev"
    bob   = "ops"
    carol = "data"
  }
}

resource "aws_iam_user" "team" {
  for_each = var.team_members

  name = each.key
}
```

This is often cleaner than `count` when you want meaningful names instead of numbered indexes.

## 3. `depends_on`

Use `depends_on` when Terraform cannot infer a dependency from configuration values alone.

```hcl
resource "aws_db_instance" "database" {
  identifier = "app-db"
  engine     = "mysql"
  instance_class = "db.t3.micro"
  username   = "admin"
  password   = "change-me"
  skip_final_snapshot = true
}

resource "aws_instance" "app" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  depends_on = [aws_db_instance.database]
}
```

This ensures the database is created before the app server starts using it.

## 4. `provider`

Use `provider` when a resource should use a specific provider configuration.

```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

resource "aws_instance" "east" {
  provider = aws.east

  ami           = "ami-12345678"
  instance_type = "t3.micro"
}

resource "aws_instance" "west" {
  provider = aws.west

  ami           = "ami-12345678"
  instance_type = "t3.micro"
}
```

This is useful when working across multiple AWS regions or accounts.

## 5. `lifecycle`

Use `lifecycle` to control resource behavior during updates, replacements, and deletion.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }
}
```

Common lifecycle settings include:

- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- `replace_triggered_by`

## 6. Why they matter

Meta-arguments are essential because they control how infrastructure is built over time. They help with:

- creating multiple identical resources
- naming repeated resources cleanly
- ordering dependencies
- directing resources to the right provider
- controlling replacement and destruction behavior

## 7. Quick comparison

- `count`: create N identical resources
- `for_each`: create resources from a map or set
- `depends_on`: force ordering between resources
- `provider`: select provider configuration
- `lifecycle`: control replacement and update behavior

## 8. Best practices

- Prefer `for_each` over `count` when names matter
- Use `depends_on` only when Terraform cannot infer the dependency
- Keep lifecycle rules explicit and intentional
- Avoid overusing `depends_on` when references already model the dependency

## 9. Example folder

This topic is documented under its own folder so it can be studied separately from type constraints and validation rules.

```text
terraform/
└── constraints/
    ├── README.md
    ├── meta-arguments/
    │   ├── README.md
    │   └── examples/
    │       └── main.tf
    └── examples/
        └── main.tf
```

## 10. Summary

Terraform meta-arguments are the hidden controls that shape resource behavior. They do not describe the resource itself; instead, they tell Terraform how to build, order, duplicate, and manage it.

That makes them a key concept when moving from simple configuration into real-world infrastructure patterns.
