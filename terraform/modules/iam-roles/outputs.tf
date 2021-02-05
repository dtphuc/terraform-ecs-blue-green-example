output "iam_role_arn" {
  value = aws_iam_role.iam_role.*.arn
}

output "iam_role_name" {
  value = aws_iam_role.iam_role.*.name
}

output "iam_policy_name" {
  value = aws_iam_policy.iam_policy.*.name
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.iam_profile.*.name
}


