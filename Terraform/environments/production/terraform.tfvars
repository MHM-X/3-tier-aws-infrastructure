environment = "production"

vpc_cidr = "10.1.0.0/16"

availability_zones = [
  "eu-north-1a",
  "eu-north-1b"
]

ami_id = "ami-0eff79517fe99e17e"

db_secret_arn = "arn:aws:secretsmanager:eu-north-1:063659476859:secret:white/production/database-bc3VAm"