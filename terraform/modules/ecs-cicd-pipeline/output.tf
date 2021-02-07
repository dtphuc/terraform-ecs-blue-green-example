
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

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}