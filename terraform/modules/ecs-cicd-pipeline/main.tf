# Create ECR Repository
module "ecr_repository" {
  source = "../../modules/ecr"

  create_ecr_repository   = true
  enable_lifecycle_policy = true
  repo_name               = ["${var.ecr_repo_name}"]
  enable_ecr_policy       = false
  enable_full_access      = false
  enable_readonly_access  = false
  principals_full_access  = "arn:aws:iam::${var.aws_account_id}:root"
  principals_read_only    = "arn:aws:iam::${var.aws_account_id}:root"
  encryption_configuration = {
    encryption_type = "AES256"
    kms_key         = null
  }
}

# ##################################################################
# # Application Load Balancer
# ##################################################################
resource "random_integer" "random_integer" {
  min = 1
  max = 99
}

module "alb" {
  source = "../../modules/alb"

  load_balancer_name        = "${var.load_balancer_name}-${random_integer.random_integer.id}"
  aws_environment           = var.aws_environment
  load_balancer_type        = var.load_balancer_type
  load_balancer_is_internal = var.load_balancer_is_internal
  vpc_id                    = var.vpc_id
  security_groups           = var.lb_security_groups
  aws_alb_subnet_ids        = var.aws_alb_subnet_ids
  http_tcp_listeners        = var.http_tcp_listeners
  https_listeners           = var.https_listeners
  target_groups             = var.target_groups
  tags                      = var.target_group_tags
  lb_tags                   = var.lb_tags
}

# ##################################################################
# # ECS Service 
# ##################################################################

module "ecs_iam_roles" {
  source                       = "../../modules/ecs-roles"
  aws_environment              = var.aws_environment
  ecs_task_role_name           = var.ecs_task_role
  ecs_task_execution_role_name = var.ecs_task_execution_role
}

module "ecs_service" {
  source = "../../modules/ecs-service"

  create_ecs_service             = var.create_ecs_service
  aws_ecs_cluster_id             = var.aws_ecs_cluster_id
  aws_region                     = var.aws_region
  aws_environment                = var.aws_environment
  aws_ecs_task_name              = var.aws_ecs_task_name
  ecs_service_name               = var.ecs_service_name
  cpu                            = var.cpu
  memory                         = var.memory
  launch_type                    = var.launch_type
  container_definitions          = var.container_definitions
  subnets                        = var.ecs_subnet_ids
  security_groups                = var.ecs_security_groups
  task_role_arn                  = module.ecs_iam_roles.ecs_task_role_arn
  execution_role_arn             = module.ecs_iam_roles.ecs_execution_role_arn
  ecs_desired_count              = var.ecs_desired_count
  deployment_max_percent         = var.deployment_max_percent
  deployment_min_healthy_percent = var.deployment_min_healthy_percent
  container_name                 = var.container_name
  container_port                 = var.container_port
  target_group_index             = module.alb.target_group_arns[0]

  # App Autoscaling
  enabled_autoscale                  = var.enabled_autoscale
  autoscale_policy_name              = var.autoscale_policy_name
  max_capacity                       = var.max_capacity
  min_capacity                       = var.min_capacity
  ecs_cluster_name                   = var.ecs_cluster_name
  app_autoscale_role                 = "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension                 = var.scalable_dimension
  service_namespace                  = var.service_namespace
  policy_type                        = var.policy_type
  adjustment_type                    = var.adjustment_type
  scale_up_cooldown_seconds          = var.scale_up_cooldown_seconds
  scale_down_cooldown_seconds        = var.scale_down_cooldown_seconds
  scale_up_metric_aggregation_type   = var.scale_up_metric_aggregation_type
  scale_down_metric_aggregation_type = var.scale_down_metric_aggregation_type
  scale_up_interval_lower_bound      = var.scale_up_interval_lower_bound
  scale_down_interval_upper_bound    = var.scale_down_interval_upper_bound
  scale_up_adjustment                = var.scale_up_adjustment
  scale_down_adjustment              = var.scale_down_adjustment

  # CloudWatch Metric
  enabled_cloudwatch_alarm       = var.enabled_cloudwatch_alarm
  aws_metric_alarm_name          = var.aws_metric_alarm_name
  aws_alarm_description          = var.aws_metric_alarm_name
  alarm_high_comparison_operator = var.alarm_high_comparison_operator
  alarm_high_evaluation_periods  = var.alarm_high_evaluation_periods
  namespace                      = var.namespace
  metric_name                    = var.metric_name
  alarm_high_period              = var.alarm_high_period
  alarm_high_statistic           = var.alarm_high_statistic
  alarm_high_threshold           = var.alarm_high_threshold
  alarm_low_comparison_operator  = var.alarm_low_comparison_operator
  alarm_low_evaluation_periods   = var.alarm_low_evaluation_periods
  alarm_low_period               = var.alarm_low_period
  alarm_low_statistic            = var.alarm_low_statistic
  alarm_low_threshold            = var.alarm_low_threshold
}

module "pipeline_roles" {
  source                        = "../../modules/codepipeline-roles"
  managed_codepipeline_rolename = "managed_codepipeline_execution_role"
  managed_codebuild_rolename    = "managed_codebuild_execution_role"
  managed_codedeploy_rolename   = "managed_codedeploy_execution_role"
  s3_bucket_name                = var.s3_bucket_name
  ecs_execution_role_arn        = module.ecs_iam_roles.ecs_execution_role_arn
  ecs_task_role_arn             = module.ecs_iam_roles.ecs_task_role_arn
}

module "codepipeline" {
  source                     = "../../modules/codepipeline"
  codepipeline_name          = var.codepipeline_name
  s3_bucket_name             = var.s3_bucket_name
  codepipeline_role_arn      = module.pipeline_roles.managed_codepipeline_role_arn
  github_token               = var.github_token
  github_repo_name           = var.github_repo_name
  github_owner               = var.github_owner
  github_branch              = var.github_branch
  codebuild_project_name     = module.build_stages.codebuild_project_arn
  codedeploy_app_name        = module.deploy_stages.codedeploy_app_name
  codedeploy_deployment_name = module.deploy_stages.codedeploy_deployment_group_id
}

module "build_stages" {
  source                  = "../../modules/codebuild"
  codebuild_project_name  = "DemoService-Build"
  codebuild_role_arn      = module.pipeline_roles.managed_codebuild_role_arn
  codebuild_agent_image   = "aws/codebuild/standard:3.0"
  ecr_repository_url      = module.ecr_repository.repository_url
  ecs_task_definition_arn = module.ecs_service.ecs_task_definition_arn
  container_name          = var.container_name
  subnet_1                = element(var.ecs_subnet_ids, 0)
  subnet_2                = element(var.ecs_subnet_ids, 1)
  security_group_1        = element(var.ecs_security_groups, 0)
  security_group_2        = element(var.ecs_security_groups, 0)
}

module "deploy_stages" {
  source                = "../../modules/codedeploy"
  create_app            = var.create_app
  ca_application_name   = var.ca_application_name
  deployment_group_name = var.deployment_group_name
  ecs_cluster_name      = var.ecs_cluster_name
  ecs_service_name      = module.ecs_service.ecs_service_name
  load_balancer_info = [
    {
      prod_traffic_route_listener_arn = module.alb.http_tcp_listener_arns[0]
      test_traffic_route_listener_arn = module.alb.http_tcp_listener_arns[1]
      blue_lb_target_group_arn        = module.alb.target_group_names[0]
      green_lb_target_group_arn       = module.alb.target_group_names[1]
    }
  ]
  auto_rollback                    = var.auto_rollback
  rollback_events                  = var.rollback_events
  action_on_timeout                = var.action_on_timeout
  wait_time_in_minutes             = var.wait_time_in_minutes
  termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
  description                      = "CodeDeploy for Blue/Green deployment"
  service_role_arn                 = module.pipeline_roles.managed_codedeploy_role_arn
  tags                             = var.codedeploy_tags
}