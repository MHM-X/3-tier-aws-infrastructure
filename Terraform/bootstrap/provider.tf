provider "aws" {
  region  = "eu-north-1"
  profile = "dev"

  default_tags {
    tags = {
      Project     = "White"
      Environment = "bootstrap"
      ManagedBy   = "Terraform"
    }
  }
}
