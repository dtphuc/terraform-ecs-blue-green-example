
output "managed_codepipeline_role_arn" {
  value = module.pipeline_roles.managed_codepipeline_role_arn
}

output "managed_codebuild_role_arn" {
  value = module.pipeline_roles.managed_codebuild_role_arn
}

output "managed_codedeploy_role_arn" {
  value = module.pipeline_roles.managed_codedeploy_role_arn
}

output "ecr_repository_url" {
  value = module.ecr_repository.repository_url
}