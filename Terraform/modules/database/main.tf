
locals {
  common_tags = {
    Project     = "White"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_subnet_group" "this" {
  name        = "white-${var.environment}-db-subnets"
  description = "Private subnets for White RDS"
  subnet_ids  = var.database_subnet_ids

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-db-subnets"
  })
}

resource "aws_db_instance" "this" {
  identifier = "white-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = 1000
  storage_type          = "gp3"
  storage_encrypted     = true

  username            = var.master_username
  password_wo         = var.db_password
  password_wo_version = 1

  db_name = var.database_name
  port    = 5432

  multi_az            = true
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.database_security_group_id]

  backup_retention_period = 7
  copy_tags_to_snapshot   = true

  performance_insights_enabled = true

  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = false

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-postgres"
  })
}
