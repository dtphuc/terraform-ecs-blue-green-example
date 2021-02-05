resource "aws_codebuild_project" "this" {
  name          = var.codebuild_project_name
  description   = "CodeBuild for ECS Blue/Green Deployment"
  build_timeout = "5"
  service_role  = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_agent_image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "TASK_DEFINITION"
      value = var.ecs_task_definition_arn
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "SUBNET_1"
      value = var.subnet_1
    }

    environment_variable {
      name  = "SUBNET_2"
      value = var.subnet_2
    }

    environment_variable {
      name  = "SECURITY_GROUP_1"
      value = var.security_group_1
    }

    environment_variable {
      name  = "SECURITY_GROUP_2"
      value = var.security_group_2
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}