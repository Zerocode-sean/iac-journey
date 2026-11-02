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

## Notes

This repo is intentionally practical and incremental. It is not meant to be a production-grade architecture, but rather a visible proof of learning over time.

The value is in the process: small wins, clear examples, and a traceable journey from beginner to more confident infrastructure builder.
