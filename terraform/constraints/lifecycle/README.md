# Terraform Lifecycle Rules

Lifecycle rules let you control how Terraform handles a resource when it changes, is replaced, or is deleted. They are part of the `lifecycle` block and are used when you need stricter operational control over infrastructure updates.

These rules do not change the meaning of the resource itself. Instead, they change how Terraform behaves when the resource is managed over time.

## What lifecycle rules do

A lifecycle block is used inside a resource block and may include settings such as:

- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- `replace_triggered_by`

These settings are especially useful in production environments where you want safer updates and fewer outages.

## 1. `create_before_destroy`

Use this when you want Terraform to create a replacement resource before destroying the old one.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

This is useful during rolling updates when you want zero downtime or a safer swap-out strategy.

## 2. `prevent_destroy`

Use this to stop a resource from being deleted or replaced by Terraform.

```hcl
resource "aws_db_instance" "primary" {
  identifier = "prod-db"
  engine     = "mysql"
  instance_class = "db.t3.micro"

  lifecycle {
    prevent_destroy = true
  }
}
```

This is a strong safety rule for important infrastructure like databases or shared services.

If someone tries to destroy it, Terraform will fail with an error.

## 3. `ignore_changes`

Use this when a resource should be managed by Terraform most of the time, but some settings should be ignored during updates.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
```

This is useful when a tag or configuration value is changed outside of Terraform and you do not want it to be reverted automatically.

## 4. `replace_triggered_by`

Use this when you want Terraform to replace a resource only when another resource changes.

```hcl
resource "aws_launch_template" "main" {
  name_prefix   = "web-"
  image_id     = "ami-12345678"
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "main" {
  name = "web-asg"

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  lifecycle {
    replace_triggered_by = [aws_launch_template.main.latest_version]
  }
}
```

This is useful when a dependency change should force a replacement instead of an in-place update.

## 5. Example: common production safety pattern

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-prod"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }
}
```

This pattern is commonly used when you want safe replacement behavior but still allow operational flexibility.

## 6. Best practices

- Use `prevent_destroy` for critical infrastructure
- Use `create_before_destroy` for low-downtime updates
- Use `ignore_changes` only when a field is intentionally managed outside Terraform
- Use `replace_triggered_by` when a dependency change requires a replacement

## 7. Why lifecycle rules matter

Lifecycle rules help you manage risk. Without them, Terraform may do unexpected in-place updates or deletions. With lifecycle rules, you can make infrastructure changes safer and more predictable.

This is especially important when working with:

- databases
- load balancers
- application servers
- networking components
- production workloads

## 8. Example folder

This topic is stored in its own folder so it can be studied separately from Terraform meta-arguments and variable constraints.

```text
terraform/
└── constraints/
    ├── lifecycle/
    │   ├── README.md
    │   └── examples/
    │       └── main.tf
```

## 9. Summary

Terraform lifecycle rules are a safety layer on top of resource management. They control when Terraform should destroy, replace, ignore, or trigger replacement behavior, which makes infrastructure updates safer and more controlled in real environments.
