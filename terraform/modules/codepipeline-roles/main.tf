/*
* IAM CodePipeline role
*/
data "aws_iam_policy_document" "assume_by_codepipeline" {
  statement {
    sid     = "AllowAssumeByCodePipeline"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "codepipeline.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "managed_codepipeline_role" {
  name               = var.managed_codepipeline_rolename
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_by_codepipeline.json
}

data "aws_iam_policy_document" "managed_codepipeline_policy" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  statement {
    sid    = "AllowCodeBuild"
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCodeDeploy"
    effect = "Allow"

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowECS"
    effect = "Allow"

    actions = [
      "ecs:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    condition {
      test     = "StringEqualsIfExists"
      values   = ["ecs-tasks.amazonaws.com"]
      variable = "iam:PassedToService"
    }

    resources = ["*"]
  }

  statement {
    sid = "AllowCodeStar"
    effect = "Allow"

    actions = [ 
      "codestar-connections:GetConnection",
      "codestar-connections:UseConnection",
      "codestar-connections:CreateConnection",
      "codestar-connections:ListConnections",
      "codestar-connections:GetInstallationUrl",
      "codestar-connections:GetIndividualAccessToken",
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_role_policy" "managed_codepipeline_policy" {
  name   = "managed_codepipeline_policy"
  role   = aws_iam_role.managed_codepipeline_role.id
  policy = data.aws_iam_policy_document.managed_codepipeline_policy.json
}

/*
* IAM CodeBuild role
*/

data "aws_iam_policy_document" "assume_by_codebuild" {
  statement {
    sid     = "AllowAssumeByCodeBuild"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "managed_codebuild_role" {
  name               = var.managed_codebuild_rolename
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_by_codebuild.json
}

data "aws_iam_policy_document" "managed_codebuild_policy" {
  statement {
    sid = "AllowS3"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  statement {
    sid = "AllowKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*",
      "kms:ListGrants",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowECR"
    effect = "Allow"

    actions = [
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid       = "AllowECSDescribeTaskDefinition"
    effect    = "Allow"
    actions   = ["ecs:DescribeTaskDefinition"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "managed_codebuild_policy" {
  name   = "managed_codebuild_policy"
  role   = aws_iam_role.managed_codebuild_role.id
  policy = data.aws_iam_policy_document.managed_codebuild_policy.json
}

/*
* IAM CodeDeploy role
*/
data "aws_iam_policy_document" "assume_by_codedeploy" {
  statement {
    sid     = "AllowAssumeByCodeBuild"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "managed_codedeploy_role" {
  name               = var.managed_codedeploy_rolename
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
}

data "aws_iam_policy_document" "managed_codedeploy_policy" {
  statement {
    sid    = "AllowLoadBalancingAndECSModifications"
    effect = "Allow"

    actions = [
      "ecs:CreateTaskSet",
      "ecs:DeleteTaskSet",
      "ecs:DescribeServices",
      "ecs:UpdateServicePrimaryTaskSet",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = [
      "${var.ecs_execution_role_arn}",
      "${var.ecs_task_role_arn}",
    ]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "managed_codedeploy_policy" {
  name   = "managed_codedeploy_policy"
  role   = aws_iam_role.managed_codedeploy_role.id
  policy = data.aws_iam_policy_document.managed_codedeploy_policy.json
}