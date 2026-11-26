variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for the White VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones for the infrastructure"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID produced by the White Packer build"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the White database secret in Secrets Manager"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  nullable    = false
}