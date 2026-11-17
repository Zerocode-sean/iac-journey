# Terraform Dynamic Blocks

Dynamic blocks are used when you need to generate repeated nested blocks in a resource without hardcoding every instance.

They are especially useful when a resource supports repeated blocks such as:

- `ingress` and `egress` rules in an AWS security group
- `tag` blocks
- `statement` blocks in IAM policies
- `listener` blocks in load balancers

A dynamic block is a loop that creates nested blocks from a collection.

## Why dynamic blocks matter

Without a dynamic block, you would have to manually write each nested block. When the number of rules or entries is variable, this becomes repetitive and hard to maintain.

Dynamic blocks let you use a list or map to generate the nested configuration automatically.

## Basic syntax

```hcl
dynamic "ingress" {
  for_each = var.ingress_rules

  content {
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
  }
}
```

In this example:

- `dynamic "ingress"` creates repeated `ingress` blocks
- `for_each` loops over a collection
- `content` defines the nested block structure
- `ingress.value` is the current item from the loop

## Example: AWS security group

```hcl
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = "vpc-12345678"

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

This is cleaner than writing multiple `ingress` blocks by hand.

## Example: generating tags dynamically

```hcl
variable "app_tags" {
  type = map(string)

  default = {
    Name      = "demo-app"
    Env       = "prod"
    ManagedBy = "terraform"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  dynamic "tag" {
    for_each = var.app_tags

    content {
      key   = tag.key
      value = tag.value
    }
  }
}
```

This pattern is useful when tag sets are created from configuration.

## When to use dynamic blocks

Use dynamic blocks when:

- the number of nested blocks is not fixed
- the configuration comes from lists or maps
- you want to avoid repetitive Terraform code
- the resource schema includes repeated nested blocks

## Best practices

- Keep the input collection structure simple and predictable
- Use `for_each` over a list or map of objects
- Keep the nested block config readable
- Avoid using dynamic blocks when a static block is clearer

## Example folder

```text
terraform/
└── constraints/
    ├── dynamic-blocks/
    │   ├── README.md
    │   └── examples/
    │       └── main.tf
```

## Summary

Dynamic blocks let Terraform generate repeated nested configuration blocks from data. They help reduce manual duplication and make infrastructure definitions easier to scale and maintain.
