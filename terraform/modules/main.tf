locals {
  role_name   = var.add_suffix ? "${var.name}-role"   : var.name
  policy_name = var.add_suffix ? "${var.name}-policy" : var.name
  group_name  = var.add_suffix ? "${var.name}-group"  : var.name
  user_name   = var.add_suffix ? "${var.name}-user"   : var.name
}

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
}