
variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "ami_id" {
  description = "ID of the prebuilt Ubuntu AMI configured by Ansible and Packer"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "ami_id must be a valid AWS AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_subnet_ids" {
  description = "Private application subnet IDs for the ASG"
  type        = list(string)
}

variable "backend_security_group_id" {
  description = "Security Group attached to backend EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the RDS-managed master secret"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by EC2"
  type        = string
  default     = "eu-north-1"
}

variable "desired_capacity" {
  description = "Desired number of backend instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of backend instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of backend instances"
  type        = number
  default     = 4
}
