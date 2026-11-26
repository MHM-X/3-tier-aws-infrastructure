
locals {
  common_tags = {
    Project     = "White"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = "White public DNS zone"

  tags = local.common_tags
}
