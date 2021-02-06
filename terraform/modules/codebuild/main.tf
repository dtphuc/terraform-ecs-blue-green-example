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
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "SERVICE_NAME"
      value = var.ecs_service_name
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
      name  = "SECURITY_GROUP_ID"
      value = var.security_group_id
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}