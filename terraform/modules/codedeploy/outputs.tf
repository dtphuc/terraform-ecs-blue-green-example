output "codedeploy_app_id" {
  value       = aws_codedeploy_app.this[0].id
  description = "Amazon's assigned ID for the application."
}

output "codedeploy_app_name" {
  value       = aws_codedeploy_app.this[0].name
  description = "The application's name."
}

output "codedeploy_deployment_group_id" {
  value       = aws_codedeploy_deployment_group.this.id
  description = "Application name and deployment group name."
}
