locals {
  role_name   = var.enable_suffix ? "${var.name}-role"   : var.name
  policy_name = var.enable_suffix ? "${var.name}-policy" : var.name
  group_name  = var.enable_suffix ? "${var.name}-group"  : var.name
  user_name   = var.enable_suffix ? "${var.name}-user"   : var.name
}

# Get the AWS account ID
data "aws_caller_identity" "current" {}


resource "aws_iam_role" "this" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for assuming the role
resource "aws_iam_policy" "this" {
  name = local.policy_name
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Resource = aws_iam_role.this.arn
      }
    ]
  })

  tags = var.tags
}


# IAM Group
resource "aws_iam_group" "this" {
  name = local.group_name
  path = "/"
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this.arn
}

# IAM User
resource "aws_iam_user" "this" {
  name = local.user_name
  path = "/"

  tags = var.tags
}

# Add user to group
resource "aws_iam_user_group_membership" "this" {
  users   = [aws_iam_user.this.name]
  group = aws_iam_group.this.name
}