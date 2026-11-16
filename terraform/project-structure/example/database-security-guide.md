# Secure RDS Database Pattern Using AWS Secrets Manager

This guide shows how to build a safe Terraform setup for an Amazon RDS database using AWS Secrets Manager, VPC/subnet isolation, and least-privilege security.

## 1. What this example does

The Terraform example creates:
- a VPC
- a public subnet
- an internet gateway and route table
- an EC2 instance
- an S3 bucket
- a secure RDS database instance in a private subnet group
- a dedicated database security group
- a secret in AWS Secrets Manager that contains database credentials

The database password is not stored in Git.

## 2. Why secrets should not be in Terraform variables

Avoid putting real credentials in:
- `variables.tf`
- `terraform.tfvars`
- checked-in `.auto.tfvars`

These files are often committed to repositories, which creates a serious risk of accidental exposure.

Best practice:
- store secret values in AWS Secrets Manager or SSM Parameter Store
- let Terraform read them at deploy time
- make variables sensitive with `sensitive = true`

## 3. Create the secret in AWS Console

1. Open the AWS Management Console.
2. Go to Services -> Secrets Manager.
3. Click "Store a new secret".
4. Choose "Other type of secret".
5. Add a JSON payload like:

```json
{
  "username": "appadmin",
  "password": "StrongPassword!123"
}
```

6. Name the secret something like:
   ```text
   prod/app/db/password
   ```
7. Leave the default encryption settings in place.
8. Save the secret.

This secret will be used by Terraform.

## 4. Reference the secret in Terraform

The database module reads the secret by ID and extracts the username and password.

Example:

```hcl
data "aws_secretsmanager_secret_version" "db" {
  secret_id = "prod/app/db/password"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_instance" "main" {
  identifier = "iac-demo-dev-db"
  engine     = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = local.db_creds["username"]
  password = local.db_creds["password"]
  skip_final_snapshot = true
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}
```

## 5. Real RDS resource pattern

The most correct resource for a standard MySQL database is `aws_db_instance`.

A secure setup includes:
- private subnet group
- security group restricting DB port access
- no public access
- secret-based credentials
- backup retention enabled
- deletion protection in production

Example pattern:

```hcl
resource "aws_db_subnet_group" "main" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db" {
  name        = "${var.db_name}-db-sg"
  description = "Database security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main" {
  identifier             = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = local.resolved_username
  password               = local.resolved_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  backup_retention_period = 7
  deletion_protection    = false
}
```

## 6. Database security concerns and best practices

### Security concerns

- passwords in source control
- public accessibility for the database
- overly open security groups
- lack of encryption at rest / in transit
- missing backup protection
- no auditing or rotation strategy

### Best practices

- Put secrets in Secrets Manager
- Keep DBs in private subnets
- Set `publicly_accessible = false`
- Restrict security groups to required CIDR blocks only
- Enable encryption at rest
- Enable automated backups
- Use multi-AZ for production
- Turn on deletion protection in production
- Rotate secrets regularly
- Use IAM roles and least-privilege policies
- Avoid broad `0.0.0.0/0` access

## 7. Recommended Terraform pattern

Use this layout:

```text
terraform/
├── modules/
│   └── database/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
└── .gitignore
```

And add to `.gitignore`:

```gitignore
*.auto.tfvars
secrets.auto.tfvars
```

## 8. Example secret file pattern

A local file for secrets can look like this, but it must not be committed:

```hcl
# secrets.auto.tfvars
# local only, do not commit

db_username = "appadmin"
db_password = "StrongPassword!123"
```

## 9. Summary

The safest and most common AWS pattern is:
- store secret in Secrets Manager
- read it in Terraform with `data "aws_secretsmanager_secret_version"`
- attach the DB to a subnet group and DB security group
- keep the database private and locked down
- avoid printing or outputting sensitive values

This gives better security and cleaner Terraform practices than hardcoding credentials in variables or tfvars files.
