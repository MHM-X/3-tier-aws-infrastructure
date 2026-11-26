output "vpc_id" {
  description = "ID of the White VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = aws_subnet.app[*].id
}

output "database_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = aws_subnet.database[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.this[*].id
}
