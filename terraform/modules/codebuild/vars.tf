variable "codebuild_project_name" {
  type        = string
  description = "CodeBuild project name"
}

variable "codebuild_role_arn" {
  type        = string
  description = "The IAM Role for CodeBuild to assume to run their jobs"
}

variable "codebuild_agent_image" {
  type        = string
  description = "CodeBuild Agent image"
  default     = "aws/codebuild/standard:3.0"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS Service Name"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "container_name" {
  type        = string
  description = "The Container name inside of the Application"
}

variable "subnet_1" {
  type        = string
  description = "The second subnet ECS to run its task"
}

variable "security_group_id" {
  type        = string
  description = "The security groups put to ECS service"
}

variable "subnet_2" {
  type        = string
  description = "The second subnet ECS to run its task"
}