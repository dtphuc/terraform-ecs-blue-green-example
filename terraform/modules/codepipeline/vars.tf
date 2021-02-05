variable "codepipeline_name" {
  type        = string
  description = "CodePipeline Name"
}

variable "codepipeline_role_arn" {
  type        = string
  description = "CodePipeline Role Arn"
}

variable "github_token" {
  type        = string
  description = "Github token to host your application code"
}

variable "github_repo_name" {
  type        = string
  description = "Github repo name"
}

variable "github_owner" {
  type        = string
  description = "Github owner"
}

variable "github_branch" {
  type        = string
  description = "Github branch"
}

variable "codebuild_project_name" {
  type        = string
  description = "CodeBuild Project Name"
}

variable "codedeploy_app_name" {
  type        = string
  description = "CodeDeploy App Name"
}

variable "codedeploy_deployment_name" {
  type        = string
  description = "CodeDeploy Deployment Group name"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket name"
}