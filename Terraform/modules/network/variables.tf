variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the White VPC"
  type        = string
}

variable "availability_zones" {
  description = "Two Availability Zones for the infrastructure"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be provided."
  }
}
