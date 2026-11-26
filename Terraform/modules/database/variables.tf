
variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "database_subnet_ids" {
  description = "Private subnet IDs for the RDS database"
  type        = list(string)

  validation {
    condition     = length(var.database_subnet_ids) >= 2
    error_message = "At least two database subnets must be provided."
  }
}

variable "database_security_group_id" {
  description = "Security Group ID attached to RDS"
  type        = string
}

variable "database_name" {
  description = "Name of the application database"
  type        = string
  default     = "white_db"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GiB"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "18.3"
}

variable "master_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "postgres"
}


variable "db_password" {
  description = "Master password supplied securely at apply time"
  type        = string
  sensitive   = true
  nullable    = false
}