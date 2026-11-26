
variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) == 2
    error_message = "The ALB must use exactly two public subnets."
  }
}

variable "alb_security_group_id" {
  description = "Security Group ID attached to the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for api.white.ps"
  type        = string
}
