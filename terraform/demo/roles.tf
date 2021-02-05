# IAM Roles and Policy

# resource "aws_s3_bucket" "this" {
#   bucket = var.s3_bucket_name
#   acl    = "private"
#   versioning {
#     enabled = true
#   }
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm     = "AES256"
#       }
#     }
#   }
#   force_destroy = true
# }

# data "aws_iam_policy_document" "managed_ecs_codedeploy_policies" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "iam:PassRole"
#     ]
#     resources = [
#       module.ecs_iam_roles.ecs_execution_role_arn,
#       module.ecs_iam_roles.ecs_task_role_arn
#     ]
#   }

#   statement {
#     sid    = "AllowS3Permission"
#     effect = "Allow"
#     actions = [
#       "s3:PutObject",
#       "s3:GetObject",
#       "s3:ListBucket"
#     ]
#     resources = [
#       "${aws_s3_bucket.this.arn}",
#       "${aws_s3_bucket.this.arn}/*"
#     ]
#   }

#   statement {
#     sid    = "AllowCodeDeployPermission"
#     effect = "Allow"
#     actions = [
#       "codedeploy:CreateCloudFormationDeployment",
#       "codedeploy:CreateDeployment",
#       "codedeploy:RegisterApplicationRevision",
#       "codedeploy:Get*"
#     ]
#     resources = [
#       "arn:aws:codedeploy:*:${var.aws_account_id}:deploymentgroup:*/*",
#       "arn:aws:codedeploy:*:${var.aws_account_id}:deploymentconfig:*",
#       "arn:aws:codedeploy:*:${var.aws_account_id}:application:*",
#     ]
#   }

#   statement {
#     sid    = "AllowECSPermission"
#     effect = "Allow"
#     actions = [
#       "ecs:RegisterTaskDefinition",
#       "ecs:DescribeTaskDefinition",
#       "ecs:DeregisterTaskDefinition"
#     ]
#     resources = [
#       "*"
#     ]
#   }
# }

# data "aws_iam_policy_document" "assume_codedeploy_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type = "Service"
#       identifiers = [
#         "codedeploy.amazonaws.com"
#       ]
#     }
#   }
# }

# module "managed_ecs_codedeploy_roles" {
#   source                    = "../modules/iam-roles"
#   create_role               = true
#   create_policy             = true
#   create_instance_profile   = false
#   aws_role_name             = var.ecs_codedeploy_roles
#   assume_role_policy        = data.aws_iam_policy_document.assume_codedeploy_role.json
#   aws_role_path             = "/"
#   max_session_duration      = "43200"
#   permissions_boundary_arn  = ""
#   iam_policy_document       = data.aws_iam_policy_document.managed_ecs_codedeploy_policies.json
#   iam_policy_name           = "managed_ecs_codedeploy_policy"
#   iam_policy_path           = "/"
#   force_detach_policies     = true
#   aws_instance_profile_name = ""
#   role_policy_arns = [
#     "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
#   ]
#   role_description = "Allow AWS Services to assume the roles."
#   tags = {
#     Environment = var.aws_environment
#   }
# }

# module "ecs_iam_roles" {
#   source                       = "../modules/ecs-roles"
#   aws_environment              = var.aws_environment
#   ecs_task_role_name           = var.ecs_task_role
#   ecs_task_execution_role_name = var.ecs_task_execution_role
# }