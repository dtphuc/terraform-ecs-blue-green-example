variable "create_ecs_cluster" {
  description = "Controls if ECS should be created"
  type        = bool
}

variable "ecs_cluster_name" {
  description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
  type        = string
}

variable "aws_environment" {
  description = "The Environment to deploy ECS Stack"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "container_insights" {
  type        = bool
  description = "enable CloudWatch Container Insights for a cluster"
}
