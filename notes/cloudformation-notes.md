# CloudFormation notes

## Basic idea
CloudFormation lets you describe AWS resources in YAML or JSON and deploy them as a stack.

## Key concepts
- Template: the infrastructure definition
- Stack: the deployed instance of a template
- Resource: an AWS service such as S3, EC2, IAM, or VPC
- Parameter: user input or configuration passed into the stack
- Output: values returned after deployment

## Recommended learning pattern
1. Draw the architecture
2. Identify required properties
3. Write the template
4. Deploy the stack
5. Validate the result
6. Delete the stack when done

## Early observations
- Small templates are the fastest way to learn
- Resource dependencies are critical
- Validation helps prevent failed deployments
- Clean-up is part of the learning process
