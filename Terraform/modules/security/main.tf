
locals {
  common_tags = {
    Project     = "White"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 1. ALB Security Group
resource "aws_security_group" "alb" {
  name        = "white-${var.environment}-alb-sg"
  description = "Allow HTTP and HTTPS traffic to the Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from the internet"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS from the internet"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_backend" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow ALB to reach Nginx on the backend EC2"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.backend.id
}

# 2. Backend Security Group
resource "aws_security_group" "backend" {
  name        = "white-${var.environment}-backend-sg"
  description = "Allow Flask traffic only from the ALB"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-backend-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id            = aws_security_group.backend.id
  description                  = "Allow HTTP traffic from the ALB to Nginx"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "backend_https" {
  security_group_id = aws_security_group.backend.id
  description       = "Allow HTTPS outbound for AWS APIs and Docker Hub"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "backend_to_database" {
  security_group_id            = aws_security_group.backend.id
  description                  = "Allow PostgreSQL traffic to the database"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.database.id
}

# 3. Database Security Group
resource "aws_security_group" "database" {
  name        = "white-${var.environment}-database-sg"
  description = "Allow PostgreSQL traffic only from the backend"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-database-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "database_from_backend" {
  security_group_id            = aws_security_group.database.id
  description                  = "Allow PostgreSQL traffic from the backend"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.backend.id
}
