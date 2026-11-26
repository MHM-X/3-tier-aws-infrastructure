
output "zone_id" {
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "Route 53 authoritative nameservers"
  value       = aws_route53_zone.this.name_servers
}
