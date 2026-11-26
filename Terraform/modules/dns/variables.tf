
variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  type        = string
}

variable "tags" {
  description = "Tags applied to DNS resources"
  type        = map(string)
  default     = {}
}
