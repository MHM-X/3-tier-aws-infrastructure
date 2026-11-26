
locals {
  common_tags = {
    Project     = "White"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-igw"
  })
}

# Public subnets: for the Application Load Balancer
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-public-${count.index + 1}"
    Tier = "public"
  })
}

# Private application subnets: for Flask EC2 instances
resource "aws_subnet" "app" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 21)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-app-${count.index + 1}"
    Tier = "private-app"
  })
}

# Private database subnets: for RDS
resource "aws_subnet" "database" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 31)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-db-${count.index + 1}"
    Tier = "private-db"
  })
}

### Route tables:

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-public-rt"
  })
}

# Route internet-bound traffic through the Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate both public subnets with the public route table
resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# One private route table per AZ
resource "aws_route_table" "private_app" {
  count = 2

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-private-app-rt-${count.index + 1}"
  })
}


# Route each app subnet's internet-bound traffic through its local NAT
resource "aws_route" "private_app_nat" {
  count = 2

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}


# Associate each app subnet with its own route table
resource "aws_route_table_association" "app" {
  count = 2

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}


# Private route table for database subnets
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-private-db-rt"
  })
}

# Associate both database subnets with the database route table
resource "aws_route_table_association" "database" {
  count = 2

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}


# Elastic IP for each NAT Gateway
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-nat-eip-${count.index + 1}"
  })
}

# One NAT Gateway in each public subnet / AZ
resource "aws_nat_gateway" "this" {
  count = 2

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-nat-${count.index + 1}"
  })

  depends_on = [
    aws_internet_gateway.this,
    aws_route.public_internet,
    aws_route_table_association.public
  ]
}