output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Name of the created IAM policy"
  value       = aws_iam_policy.this.name
}

output "group_name" {
  description = "Name of the created IAM group"
  value       = aws_iam_group.this.name
}

output "group_arn" {
  description = "ARN of the created IAM group"
  value       = aws_iam_group.this.arn
}

output "user_arn" {
  description = "ARN of the created IAM user"
  value       = aws_iam_user.this.arn
}

output "user_name" {
  description = "Name of the created IAM user"
  value       = aws_iam_user.this.name
}