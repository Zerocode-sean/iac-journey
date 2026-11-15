# Terraform Outputs and Variables

## 1. Variables

Variables are the inputs to your Terraform configuration.
They let you customize values without hardcoding them directly into the code.

Example:

```hcl
variable "aws_region" {
  description = "AWS region to deploy the resources into"
  type        = string
  default     = "us-west-2"
}
```

You can use variables in resources like this:

```hcl
provider "aws" {
  region = var.aws_region
}
```

Variables can come from:
- default values in the code
- `.tfvars` files
- environment variables
- command line arguments

Example `.tfvars`:

```hcl
aws_region = "us-east-1"
bucket_name = "my-demo-bucket"
```

### Why variables matter
- make the config reusable
- avoid hardcoded values
- support different environments like dev, test, prod

---

## 2. Outputs

Outputs are values Terraform exposes after a successful apply.
They are useful for showing important resource information or passing values to other systems.

Example:

```hcl
output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}
```

After running:

```bash
terraform apply
```

You can view them with:

```bash
terraform output
```

Or a specific output:

```bash
terraform output bucket_id
```

### Typical output examples
- public IP of an EC2 instance
- S3 bucket name or ARN
- VPC ID
- database endpoint
- generated resource IDs

---

## 3. Outputs vs Variables

The easiest way to remember it:

- Variables = inputs to Terraform
- Outputs = values produced by Terraform

### Example

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

resource "aws_s3_bucket" "example" {
  bucket = "demo-${var.environment}-bucket"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

In this example:
- `var.environment` is provided by the user or default
- the bucket gets created from that input
- `output "bucket_name"` shows the resulting bucket name

---

## 4. Outputs in Modules

Terraform modules can also define outputs.
A module can accept input variables and return output values to the parent configuration.

### Child module example

`modules/network/main.tf`

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

output "vpc_id" {
  value = aws_vpc.main.id
}
```

Parent configuration:

```hcl
module "network" {
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
}

output "network_vpc_id" {
  value = module.network.vpc_id
}
```

This is a common pattern for reusable infrastructure code.

### Why this is useful
- keep modules self-contained
- expose only the values that matter
- pass important values from child modules into the root configuration

---

## 5. Sensitive Outputs

Sensitive outputs hide values in the CLI so they are not shown in plain text.

Example:

```hcl
output "database_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}
```

This does not mean the value is removed from Terraform state.
It still exists in state storage, but Terraform will mask it from normal output.

Use `sensitive = true` for:
- passwords
- private keys
- access tokens
- secret connection strings

Example command:

```bash
terraform output
```

With a sensitive output, the value may appear as:

```text
database_password = (sensitive value)
```

---

## 6. How Outputs Relate to This Project

In our current Terraform files:

- `variables.tf` defines input variables like `aws_region`, `bucket_name`, and `cidr_block`
- `main.tf` uses those variables in the AWS resources
- there is an output block at the end of `main.tf`

Current example:

```hcl
output "name" {
  value = aws_vpc.lab_vpc.name
}
```

This is a good example of an output, but there is one important issue:

`aws_vpc.lab_vpc.name` is not a valid attribute for an AWS VPC resource.
`aws_vpc` does not have a `name` property the way some resources do.

A better output would be one of these:

```hcl
output "vpc_id" {
  value = aws_vpc.lab_vpc.id
}
```

or

```hcl
output "vpc_name_tag" {
  value = aws_vpc.lab_vpc.tags["Name"]
}
```

The VPC does have a `Name` tag, so the tag value is valid. The resource ID is usually the most common and reliable output.

Example of a cleaner output pattern:

```hcl
output "vpc_id" {
  value = aws_vpc.lab_vpc.id
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}
```

This gives you useful values after apply.

---

## 7. Terraform `.tfvars` example

In this project, you can store values in a file named `terraform.tfvars` so Terraform automatically loads them.

Example:

```hcl
aws_region    = "us-west-2"
bucket_name   = "iac-terraform-bucket-v1"
environment   = "dev"
aws_vpc_region = ["us-west-2"]
cidr_block    = "192.168.0.0/16"
subnet        = "192.168.1.0/24"
```

This is useful because:
- the same configuration can be reused for different environments
- you can keep secret or environment-specific values out of the main Terraform code
- `terraform apply` will automatically read these values

If you want to use a different file name, you can do:

```bash
terraform apply -var-file=dev.tfvars
```

---

## 8. Using Terraform outputs in a script

Terraform outputs are often used by scripts, CI/CD pipelines, and deployment automation.

Example:

```bash
terraform output -raw vpc_id
```

This returns the value of the output as plain text, which can be used in a shell script:

```bash
#!/usr/bin/env bash
set -e

VPC_ID=$(terraform output -raw vpc_id)
BUCKET_ID=$(terraform output -raw s3_bucket_id)

echo "VPC ID: $VPC_ID"
echo "S3 Bucket ID: $BUCKET_ID"
```

For this project, that is useful because the output can tell you:
- which VPC was created
- which S3 bucket was created
- what values other automation should use next

In a real pipeline, you might pass these values into:
- AWS CLI commands
- deployment scripts
- configuration files
- other Terraform modules

---

## 9. Locals in this project

`locals` let you define reusable values inside Terraform without exposing them as variables.
They are helpful for things that are derived or repeated often.

In your current project, `main.tf` now includes:

```hcl
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "iac-journey"
  }
}
```

Then the resource tags reuse it with `merge()`:

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = merge(local.common_tags, {
    Name = var.bucket_name
  })
}
```

Why this is useful:
- avoids repeating the same tag values everywhere
- makes tags consistent across resources
- keeps configuration easier to maintain

For a real project, locals are often used for:
- common tags
- computed names
- derived values
- reusable configuration snippets

---

## 10. Terraform state

Terraform state is the file Terraform uses to track what it created and what the current configuration should match.

In a standard Terraform project, the state file is usually:

```text
terraform.tfstate
```

This file stores mappings like:
- resource IDs
- attributes of created resources
- metadata Terraform needs to plan and apply changes

In your workspace, there is already a file:

- `terraform/terraform.tfstate`

This matters because:
- Terraform uses the state to understand what already exists
- without it, Terraform would not know which AWS resources to manage
- your outputs are based on resource values stored in state

Important note:
- state often includes sensitive values and should be protected
- in real teams, state is usually stored remotely in a secure backend such as S3 + DynamoDB, or Terraform Cloud

For example, the `vpc_id` output is based on data Terraform reads from the VPC resource in state after apply.

---

## 11. Best Practices

- define variables for values that change between environments
- use `.tfvars` files for environment-specific configuration
- use outputs for values you need after deployment
- use `locals` for repeated or derived values
- protect sensitive data with `sensitive = true`
- keep Terraform state secure and back it up properly

---

## 12. Example Full Pattern

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "app" {
  bucket = "demo-${var.environment}-bucket"

  tags = merge(local.common_tags, {
    Name = "demo-bucket"
  })
}

output "bucket_name" {
  value = aws_s3_bucket.app.bucket
}
```

This shows the full loop:
1. values come from variables or `.tfvars`
2. locals help reuse common config
3. resources are created
4. outputs expose the final values
5. scripts or CI can consume those outputs

---

## 13. Real-world workflow

A typical Terraform workflow looks like this:

```bash
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

What each step does:
- `terraform init` downloads providers and initializes the working directory
- `terraform plan` shows what Terraform will create, update, or destroy
- `terraform apply` creates or updates the infrastructure
- `terraform output` displays the output values such as VPC ID or S3 bucket ARN
- `terraform destroy` removes the infrastructure managed by Terraform

Example flow for this project:

```bash
cd terraform
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

This is the normal lifecycle for experimenting with AWS infrastructure in a learning project like this one.

---

## Summary

- Variables are inputs
- Outputs are results
- `.tfvars` files store values for different environments
- `locals` reduce repetition and keep config clean
- Terraform state tracks real infrastructure and is essential for outputs and future changes
- In this project, outputs help surface the created VPC and S3 bucket details after deployment
