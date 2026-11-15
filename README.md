# IaC Journey

![AWS](https://img.shields.io/badge/AWS-CloudFormation%20%2B%20Terraform-FF9900?logo=amazonaws&logoColor=white)
![GitHub](https://img.shields.io/badge/Status-Personal%20Learning%20Lab-181717?logo=github)
![License](https://img.shields.io/badge/License-Portfolio%20Learning-8A2BE2)

A personal learning repository for Infrastructure as Code (IaC) on AWS, focused on hands-on practice with CloudFormation and Terraform.

This repo is both a lab and a journal: I build small cloud architectures, deploy them in AWS, validate the result, clean them up, and document what I learn along the way.

## Current status

- Foundation setup complete
- Repo structure created for CloudFormation, Terraform, and notes
- First exercise in progress: simple S3 bucket deployment with CloudFormation
- Learning focus: resource basics, dependencies, and deployment workflow

## Why this repo exists

The goal is to learn by doing and build real confidence in infrastructure automation:

- draw the architecture before writing code
- identify required resource properties and dependencies
- define infrastructure declaratively
- deploy resources in AWS
- validate the behavior in the console
- remove resources cleanly when finished
- keep a visible record of progress and lessons learned

## Learning path

### 1. Foundations
- AWS account and billing awareness
- basic cloud concepts and resource relationships
- understanding IaC as declarative configuration

### 2. CloudFormation basics
- stacks and templates
- required properties vs optional properties
- simple resources such as S3 buckets
- `Ref` and dependency wiring

### 3. Terraform basics
- providers, resources, variables, and outputs
- state management and local workflows
- moving from manual deployment to repeatable automation

### 4. Real-world patterns
- networking foundations
- security groups and access control
- storage and compute combinations
- environment separation and cleanup discipline

## Project structure

- `cloudformation/` — CloudFormation templates and exercises
  - `cloudformation/01-s3/` — first S3 bucket example
- `terraform/` — Terraform experiments and infrastructure exercises
- `notes/` — daily notes, lessons learned, and surprises

## Journal

### Day 1

- Set up the repository structure and learning workflow
- Created the initial repo folders and GitHub-ready documentation
- Started with the first CloudFormation exercise: a minimal S3 bucket
- Learned that the key to IaC is understanding dependencies before writing the template

### Day 2

- Focus on required properties and AWS resource basics
- Validate the stack in the AWS console and inspect the result
- Practice cleanup to keep the environment safe and organized
- Confirm that small, repeatable exercises are the best way to learn infrastructure

## Current focus

The first exercise is a minimal S3 bucket deployment using CloudFormation.

This introduces:

- creating a basic AWS resource with IaC
- identifying required properties
- deploying a stack from a template
- checking the deployed result in the AWS console
- deleting the stack after learning is complete

## Learning workflow

Each exercise follows the same pattern:

1. Draw the architecture on paper
2. Identify the required properties
3. Define the infrastructure in code
4. Deploy it to AWS
5. Validate the result in the console
6. Remove the stack or resource cleanly
7. Write down the lesson, surprise, or mistake

## Day-to-day Terraform workflow

For most Terraform exercises in this repo, the standard flow is:

```bash
cd terraform
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

What each step means:
- `terraform init` initializes the working directory and downloads the required providers
- `terraform plan` shows the exact changes Terraform will make
- `terraform apply` creates or updates the AWS resources
- `terraform output` shows the values exposed by outputs such as VPC IDs or bucket identifiers
- `terraform destroy` removes the infrastructure cleanly when the exercise is finished

This workflow keeps the process repeatable, easy to validate, and safe for learning labs.

## Terraform state and remote backends

Terraform state is the record of what Terraform manages. It tells Terraform what resources exist and what values they currently have, so it can plan future changes.

For learning exercises, local state is fine. For real teams, most organizations use a remote backend such as:

- S3 for storing the state file
- DynamoDB for state locking

This matters because it helps avoid overlapping apply operations and protects the team from writing conflicting changes at the same time.

A classic pattern is:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "dev/network/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

This is especially important when multiple engineers are working on the same environment.

### State locking and drift

State locking prevents two engineers from applying changes at the same time. The lock owner is the active Terraform process holding the lock, and other runs must wait until it is released.

Drift happens when a resource is changed outside Terraform, such as in the AWS console. Terraform will compare the live infrastructure against the state file and configuration and show those differences during the next plan.

This is why GitOps is valuable: code in Git becomes the desired state, while Terraform state and live infrastructure are reconciled against that intent.

The repo now includes a dedicated notes folder for this topic:

- `terraform/state-backend/`

### Backend config note

A file like `terraform/state-backend/backend.tfvars.example` is not the same as a normal Terraform variable file used for resources.

It is typically used as a backend configuration file for `terraform init`, for example:

```bash
terraform init -backend-config=backend.tfvars
```

This is different from `terraform.tfvars`, which is used to populate normal input variables such as region, environment, or bucket names.

This distinction matters when working with remote state: the backend settings tell Terraform where the remote state lives and how to lock it, while regular variable files provide values for the infrastructure itself.

---

## Notes

This repo is intentionally practical and incremental. It is not meant to be a production-grade architecture, but rather a visible proof of learning over time.

The value is in the process: small wins, clear examples, and a traceable journey from beginner to more confident infrastructure builder.
