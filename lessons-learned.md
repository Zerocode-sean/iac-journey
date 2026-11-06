# Lessons Learned

This file captures the practical mistakes, AWS permission issues, and troubleshooting lessons encountered while learning Infrastructure as Code.

## 1. Terraform S3 AccessDenied due to IAM policy restriction

### Date
November 6, 2026

### Problem
A Terraform deployment for an S3 bucket failed with an AWS IAM `AccessDenied` error:

- `s3:GetBucketObjectLockConfiguration`
- `explicit deny in an identity-based policy: arn:aws:iam::387769759230:policy/Pvoclabs2`

### What happened
We attempted to deploy Terraform resources that included an S3 bucket. The plan looked correct, but the apply failed during bucket creation.

The error showed that the active AWS identity in the terminal was not authorized to perform a required S3 API action.

### Error summary
`User: arn:aws:sts::387769759230:assumed-role/voclabs/user5360541=John_Mutua_Ndinda_ is not authorized to perform: s3:GetBucketObjectLockConfiguration on resource: "arn:aws:s3:::iac-terraform-bucket-v1" with an explicit deny in an identity-based policy: arn:aws:iam::387769759230:policy/Pvoclabs2`

### Why this happened
Terraform performs additional API calls while managing S3 resources beyond simply creating the bucket. In this case, it was checking the bucket object lock configuration, which was explicitly denied by the attached IAM policy.

This is a permissions issue rather than a Terraform syntax issue.

### Why CloudFormation worked
CloudFormation was able to create the S3 bucket in the lab environment because it was likely running under a different execution context, role, or identity than the current Terraform session.

This showed us that:
- IAM identity matters as much as the code itself
- different IaC tools can behave differently under different role assumptions
- permissions must be verified before assuming the infrastructure code is broken

### How we tackled it
We verified the following:
- the Terraform configuration was valid
- the error was coming from AWS IAM, not from HCL syntax
- the current AWS user/role was denied access to the S3 bucket configuration call

### Lesson learned
When Terraform fails on AWS resource creation, do not assume the code is wrong. Always check:
- the active AWS profile/role
- the attached IAM policies
- whether the identity has a deny rule blocking required API calls

### Practical takeaway
We learned that a CloudFormation success does not automatically guarantee the same permissions for Terraform in the same AWS environment. Always validate the active credentials and policies before debugging infrastructure code.

### Follow-up
For this lab, the S3 resource was temporarily not suitable under the current IAM restrictions. We moved to a simpler Terraform learning flow focused on valid provider resources and correct Terraform syntax while we worked around the permission issue.
