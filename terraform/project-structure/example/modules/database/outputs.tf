output "db_identifier" {
  description = "The identifier of the database instance"
  value       = aws_db_instance.main.id
}

output "db_address" {
  description = "The hostname of the database instance"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.main.port
}

output "db_security_group_id" {
  description = "The security group ID used by the database"
  value       = aws_security_group.db.id
}
