output "load_balancer_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.load_balancer_id
}

output "load_balancer_name" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.load_balancer_name
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "load_balancer_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb.load_balancer_arn_suffix
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_ids
}


output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.alb.target_group_names
}

output "codedeploy_app_id" {
  value       = module.codedeploy.codedeploy_app_id
  description = "Amazon's assigned ID for the application."
}

output "codedeploy_app_name" {
  value       = module.codedeploy.codedeploy_app_name
  description = "The application's name."
}

output "codedeploy_deployment_group_id" {
  value       = module.codedeploy.codedeploy_deployment_group_id
  description = "Application name and deployment group name."
}
