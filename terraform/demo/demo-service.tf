# ##################################################################
# # Application Load Balancer
# ##################################################################
resource "random_integer" "demo_service_random" {
  min = 1
  max = 99
}

data "template_file" "demo_service" {
  template = file("${path.module}/../templates/ecs_task/ecs_demo_service_task_def.json")
  vars = {
    container_name  = var.container_name
    container_image = "${module.demo_service.ecr_repository_url}:latest"
    awslogs_group   = "/ecs/"
    awslogs_region  = var.aws_region
    awslogs_stream_prefix = var.ecs_service_name
  }
}

module "demo_service" {
  source = "../modules/ecs-cicd-pipeline"

  load_balancer_name = "demo-service-alb"
  aws_environment    = var.aws_environment
  load_balancer_type = "application"

  vpc_id = module.vpc.vpc_id
  lb_security_groups = [
    module.defaultSecGroup_Public.*.security_group_id[0],
    module.defaultSecGroup_PrivateOnly.*.security_group_id[0]
  ]
  aws_alb_subnet_ids = module.vpc.public_subnet_ids

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    # Live Listener
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    },
    # Test Listener
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 1
      action_type        = "forward"
    },
  ]

  target_groups = [
    {
      name                 = "tg-demo-service-blue-${random_integer.demo_service_random.id}"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        TargetGroupTag = "tg-demo-service-blue-${random_integer.demo_service_random.id}"
      }
    },
    {
      name                 = "tg-demo-service-green-${random_integer.demo_service_random.id}"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        TargetGroupTag = "tg-demo-service-blue-${random_integer.demo_service_random.id}"
      }
    },
  ]

  target_group_tags = {
    BusinessUnit = "DevOps"
  }

  lb_tags = {
    LoadBalancer    = "demo-service-lb"
    ApplicationName = "demo-service"
    Function        = "LoadBalancer"
  }

  # Define ECS Service
  create_ecs_service    = true
  aws_ecs_cluster_id    = module.ecs_cluster.ecs_cluster_id
  aws_region            = var.aws_region
  aws_ecs_task_name     = "demo-service"
  ecs_service_name      = var.ecs_service_name
  ecr_repo_name         = "demo-service"
  cpu                   = "256"
  memory                = "512"
  launch_type           = "FARGATE"
  container_definitions = data.template_file.demo_service.rendered
  ecs_subnet_ids        = module.vpc.private_subnet_ids
  ecs_security_groups = [
    module.defaultSecGroup_PrivateEgressAll.*.security_group_id[0],
    module.defaultSecGroup_PrivateOnly.*.security_group_id[0]
  ]
  ecs_task_role                  = var.ecs_task_role
  ecs_task_execution_role        = var.ecs_task_execution_role
  ecs_desired_count              = 1
  deployment_max_percent         = 200
  deployment_min_healthy_percent = 100
  container_name                 = var.container_name
  container_port                 = var.container_port

  # App Autoscaling
  enabled_autoscale                  = true
  autoscale_policy_name              = "demo-service-autoscale"
  max_capacity                       = "2"
  min_capacity                       = "1"
  ecs_cluster_name                   = module.ecs_cluster.ecs_cluster_name
  scalable_dimension                 = "ecs:service:DesiredCount"
  service_namespace                  = "ecs"
  policy_type                        = "StepScaling"
  adjustment_type                    = "ChangeInCapacity"
  scale_up_cooldown_seconds          = "300"
  scale_down_cooldown_seconds        = "300"
  scale_up_metric_aggregation_type   = "Average"
  scale_down_metric_aggregation_type = "Average"
  scale_up_interval_lower_bound      = "0"
  scale_down_interval_upper_bound    = "0"
  scale_up_adjustment                = "1"
  scale_down_adjustment              = "-1"

  # CloudWatch Metric
  enabled_cloudwatch_alarm       = "true"
  aws_metric_alarm_name          = "demo-service-cloudwatch-ecs"
  aws_alarm_description          = "CloudWatch monitor Docgen ECS Cluster/Service"
  alarm_high_comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_high_evaluation_periods  = "1"
  namespace                      = "AWS/ECS"
  metric_name                    = "CPUUtilization"
  alarm_high_period              = "60"
  alarm_high_statistic           = "Average"
  alarm_high_threshold           = "75"
  alarm_low_comparison_operator  = "LessThanOrEqualToThreshold"
  alarm_low_evaluation_periods   = "3"
  alarm_low_period               = "60"
  alarm_low_statistic            = "Average"
  alarm_low_threshold            = "30"

  # Define Deploy
  create_app            = true
  aws_account_id        = var.aws_account_id
  ca_application_name   = "demo-service-codedeploy"
  deployment_group_name = "demo-service-codedeploy"
  auto_rollback         = true
  rollback_events       = ["DEPLOYMENT_FAILURE"]
  action_on_timeout     = "CONTINUE_DEPLOYMENT"
  #wait_time_in_minutes             = 5
  termination_wait_time_in_minutes = 10
  description                      = "CodeDeploy for Blue/Green deployment"
  codedeploy_tags = {
    Environment  = "dev"
    BusinessUnit = "DevOps"
    Function     = "ECSCodeDeploy"
  }
  # Define CodeBuild
  s3_bucket_name   = aws_s3_bucket.this.id

  # Define CodePipeline
  github_token     = var.github_token
  github_repo_name = "terraform-ecs-blue-green-example"
  github_owner     = "dtphuc"
  github_branch    = "master"
  codepipeline_name = "demo-service-codepipeline"
}