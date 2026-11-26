
output "db_instance_id" {
  description = "Identifier of the White RDS instance"
  value       = aws_db_instance.this.identifier
}

output "db_endpoint" {
  description = "Endpoint of the White RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "Port used by PostgreSQL"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the White application database"
  value       = aws_db_instance.this.db_name
}
