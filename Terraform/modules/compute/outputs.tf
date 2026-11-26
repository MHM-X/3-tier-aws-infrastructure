
output "launch_template_id" {
  description = "ID of the Terraform-managed Launch Template"
  value       = aws_launch_template.backend.id
}

output "launch_template_latest_version" {
  description = "Latest version of the Launch Template"
  value       = aws_launch_template.backend.latest_version
}

output "autoscaling_group_name" {
  description = "Name of the backend Auto Scaling Group"
  value       = aws_autoscaling_group.backend.name
}

output "autoscaling_group_arn" {
  description = "ARN of the backend Auto Scaling Group"
  value       = aws_autoscaling_group.backend.arn
}
