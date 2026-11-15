# Terraform Providers

A Terraform provider is a plugin that lets Terraform talk to a specific platform or service.

In this project, we are using the AWS provider so Terraform can create and manage AWS resources such as S3 buckets and VPCs.

## What a provider does

A provider knows:
- which API to call
- what resource types it supports
- how to translate Terraform configuration into real cloud changes

Without a provider, Terraform would not know how to create AWS resources.

## Example: AWS provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
```

This is the same pattern used in the main Terraform configuration for this repo.

## Why this matters in this project

The AWS provider is what allows Terraform to:
- create an S3 bucket
- create a VPC
- attach policies and tags
- manage other AWS resources

## Provider configuration

Common provider settings include:
- region
- profile
- access key / secret key (less common in real cloud setups)
- shared credentials or IAM roles

In AWS, the provider often uses:
- environment variables
- AWS CLI config
- IAM roles on EC2 or other compute environments

## Important workflow step

Whenever you add or change a provider block, run:

```bash
terraform init
```

This downloads the provider plugin so Terraform can use it.

## Basic rule

- `required_providers` = declare which providers the configuration depends on
- `provider "aws"` = configure how Terraform connects to that provider

## Example from this repo

The root `terraform/main.tf` file already uses:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

This tells Terraform to use the AWS provider and deploy resources in the selected AWS region.

## Providers beyond AWS

Terraform is not limited to AWS. Providers exist for many platforms and services, including:

- Azure (`hashicorp/azurerm`)
- Google Cloud (`hashicorp/google`)
- Kubernetes (`hashicorp/kubernetes`)
- Docker (`kreuzwerker/docker`)
- GitHub (`integrations/github`)
- Cloudflare (`cloudflare/cloudflare`)

Each provider is responsible for a different API and exposes different resource types.

Example:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

The pattern is always the same: declare the provider, configure it, then use its resources.

## Provider vs resource vs module

This is a common Terraform distinction:

- Provider: the plugin that connects Terraform to a platform or service
- Resource: a concrete object managed by that provider, such as an S3 bucket or VPC
- Module: a reusable grouping of Terraform configuration that can contain variables, resources, and outputs

Example:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "demo-bucket"
}

module "network" {
  source = "./modules/network"
}
```

In plain terms:
- the provider lets Terraform talk to AWS
- the resource is the actual AWS object being created
- the module is a reusable bundle of Terraform logic

This distinction is important as your infrastructure grows beyond a single file.

## Next steps

As you go deeper into Terraform, you will commonly run into these patterns:

### 1. Provider aliases

Provider aliases let you configure the same provider multiple times with different settings.

Example:

```hcl
provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

provider "aws" {
  region = "us-east-1"
  alias  = "east"
}
```

This is useful when you want to manage resources in multiple AWS regions from the same configuration.

### 2. Region and profile configuration

The AWS provider can be configured with values such as:

```hcl
provider "aws" {
  region  = "us-west-2"
  profile = "my-profile"
}
```

This uses a named AWS CLI profile instead of relying on default environment settings. In real-world setups, you often use IAM roles, environment variables, or shared credentials instead of hardcoded keys.

### 3. Multiple providers in one project

A single Terraform project can use more than one provider.

Example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
```

This is common in larger projects where AWS resources and Kubernetes resources are managed together.

The main idea is simple: each provider handles a different platform, and Terraform coordinates them in one configuration.

## In one sentence

Terraform providers are the bridge between your configuration and the real service you are managing.
