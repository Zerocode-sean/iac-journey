output "vpc_id" {
  description = "The VPC created for the environment"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "The public subnet ID"
  value       = module.networking.public_subnet_id
}

output "ec2_instance_id" {
  description = "The EC2 instance ID"
  value       = module.ec2.instance_id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.storage.bucket_name
}
