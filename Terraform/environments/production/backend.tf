terraform {
  backend "s3" {
    bucket       = "white-tfstate-mahmoud-2026-unique9274"
    key          = "white/production/terraform.tfstate"
    region       = "eu-north-1"
    profile      = "dev"
    encrypt      = true
    use_lockfile = true
  }
}
