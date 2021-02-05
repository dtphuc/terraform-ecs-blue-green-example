output "ecs_service_name" {
  description = "The name of the ECS cluster"
  value       = "${var.ecs_service_name}"
}

output "ecs_task_definition_arn" {
  description = "The ECS Task Definition ARN"
  value = aws_ecs_task_definition.this.arn
}