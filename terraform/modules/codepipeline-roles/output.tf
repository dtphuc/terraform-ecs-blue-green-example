
output "managed_codepipeline_role_arn" {
  value = aws_iam_role.managed_codepipeline_role.arn
}

output "managed_codebuild_role_arn" {
  value = aws_iam_role.managed_codebuild_role.arn
}

output "managed_codedeploy_role_arn" {
  value = aws_iam_role.managed_codedeploy_role.arn
}