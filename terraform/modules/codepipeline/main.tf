resource "aws_codestarconnections_connection" "this" {
  name          = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "this" {
  name     = var.codepipeline_name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifacts"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.this.arn
        FullRepositoryId = "${var.github_repo_name}"
        BranchName       = "${var.github_branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifacts"]
      output_artifacts = ["BuildArtifacts"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifacts"]
      version         = "1"

      configuration = {
        ApplicationName                = "${var.codedeploy_app_name}"
        DeploymentGroupName            = "${var.codedeploy_deployment_name}"
        TaskDefinitionTemplateArtifact = "BuildArtifacts"
        AppSpecTemplateArtifact        = "BuildArtifacts"
      }
    }
  }
}