
output "alb_security_group_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "backend_security_group_id" {
  description = "Security Group ID for the backend EC2 instances"
  value       = aws_security_group.backend.id
}

output "database_security_group_id" {
  description = "Security Group ID for the RDS database"
  value       = aws_security_group.database.id
}
