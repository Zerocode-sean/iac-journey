output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "public_instance_id" {
  value = aws_instance.public_web.id
}

output "public_instance_public_ip" {
  value = aws_instance.public_web.public_ip
}
