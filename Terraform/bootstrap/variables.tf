variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string

  validation {
    condition = (
      length(var.state_bucket_name) >= 3 &&
      length(var.state_bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.state_bucket_name))
    )

    error_message = "The bucket name must be 3-63 characters, use lowercase letters, digits, dots, and hyphens, and start and end with a letter or digit."
  }
}
