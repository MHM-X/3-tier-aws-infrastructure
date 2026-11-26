
module "network" {
  source = "../../modules/network"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}


module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.network.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id

  certificate_arn = "arn:aws:acm:eu-north-1:063659476859:certificate/965affe2-4794-488e-8259-269fa5c804bd"
}


module "compute" {
  source = "../../modules/compute"

  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = "t3.micro"

  app_subnet_ids            = module.network.app_subnet_ids
  backend_security_group_id = module.security.backend_security_group_id
  target_group_arn          = module.alb.target_group_arn

  db_secret_arn = var.db_secret_arn
  aws_region    = "eu-north-1"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4
}

module "database" {
  source = "../../modules/database"

  environment = var.environment

  database_subnet_ids = module.network.database_subnet_ids

  database_security_group_id = module.security.database_security_group_id
  db_password                = var.db_password
}



module "dns" {
  source = "../../modules/dns"

  domain_name = "white.ps"

  alb_dns_name = "white-production-alb-756077367.eu-north-1.elb.amazonaws.com"
}

