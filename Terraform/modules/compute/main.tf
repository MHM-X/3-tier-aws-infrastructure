
locals {
  common_tags = {
    Project     = "White"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# EC2 assumes this role to retrieve the RDS-managed secret.
resource "aws_iam_role" "backend" {
  name = "white-${var.environment}-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "read_database_secret" {
  name = "white-${var.environment}-read-db-secret"
  role = aws_iam_role.backend.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue"
      ]

      Resource = var.db_secret_arn
    }]
  })
}

resource "aws_iam_instance_profile" "backend" {
  name = "white-${var.environment}-backend-profile"
  role = aws_iam_role.backend.name

  tags = local.common_tags
}

# Launch Template uses the AMI prepared by Ansible and Packer.
resource "aws_launch_template" "backend" {
  name                   = "white-${var.environment}-backend-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  update_default_version = true

  vpc_security_group_ids = [
    var.backend_security_group_id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.backend.name
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "white-${var.environment}-backend"
    })
  }

  tags = merge(local.common_tags, {
    Name = "white-${var.environment}-backend-template"
  })
}

# ASG creates instances using the Launch Template.
resource "aws_autoscaling_group" "backend" {
  name                = "white-${var.environment}-backend-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.app_subnet_ids

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.backend.id
    version = tostring(aws_launch_template.backend.latest_version)
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "white-${var.environment}-backend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = local.common_tags.Project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = local.common_tags.Environment
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = local.common_tags.ManagedBy
    propagate_at_launch = true
  }

  depends_on = [
    aws_iam_role_policy.read_database_secret
  ]
}
