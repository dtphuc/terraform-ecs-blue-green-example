variable "managed_codepipeline_rolename" {
  type        = string
  description = "AWS CodePipeline Role name"
}

variable "managed_codebuild_rolename" {
  type        = string
  description = "AWS CodeBuild Role name"
}

variable "managed_codedeploy_rolename" {
  type        = string
  description = "AWS CodeBuild Role name"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket name to host artifacts"
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "ECS Task Execution Role arn"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ECS Task Role arn"
}