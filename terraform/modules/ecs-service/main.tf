# Create Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.aws_ecs_task_name
  container_definitions    = var.container_definitions
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["EC2", "FARGATE"]
  tags = {
    Name        = var.aws_ecs_task_name
    Environment = var.aws_environment
    ManagedBy   = "Terraform"
  }
  # lifecycle {
  #   ignore_changes = [
  #     container_definitions
  #   ]
  # }
}

# Create ECS Resources
resource "aws_ecs_service" "this" {
  count           = var.create_ecs_service ? 1 : 0
  name            = var.ecs_service_name
  cluster         = var.aws_ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.family
  desired_count   = var.ecs_desired_count

  deployment_maximum_percent         = var.deployment_max_percent
  deployment_minimum_healthy_percent = var.deployment_min_healthy_percent
  launch_type                        = var.launch_type
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  load_balancer {
    target_group_arn = var.target_group_index
    container_name   = var.container_name
    container_port   = var.container_port
  }
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count
    ]
  }
}

# Application AutoScaling Resources
resource "aws_appautoscaling_target" "this" {
  count              = var.enabled_autoscale ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${element(aws_ecs_service.this.*.name, count.index)}"
  role_arn           = var.app_autoscale_role
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
  depends_on = [
    aws_ecs_service.this
  ]
}

resource "aws_appautoscaling_policy" "scale_up" {
  count              = var.enabled_autoscale ? 1 : 0
  name               = "${var.autoscale_policy_name}-ScaleUp"
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.ecs_cluster_name}/${element(aws_ecs_service.this.*.name, count.index)}"
  scalable_dimension = var.scalable_dimension
  policy_type        = var.policy_type

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.scale_up_cooldown_seconds
    metric_aggregation_type = var.scale_up_metric_aggregation_type

    step_adjustment {
      metric_interval_lower_bound = var.scale_up_interval_lower_bound
      scaling_adjustment          = var.scale_up_adjustment
    }
  }

  depends_on = [
    aws_appautoscaling_target.this
  ]
}

resource "aws_appautoscaling_policy" "scale_down" {
  count              = var.enabled_autoscale ? 1 : 0
  name               = "${var.autoscale_policy_name}-ScaleDown"
  service_namespace  = var.service_namespace
  resource_id        = "service/${var.ecs_cluster_name}/${element(aws_ecs_service.this.*.name, count.index)}"
  scalable_dimension = var.scalable_dimension
  policy_type        = var.policy_type

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.scale_down_cooldown_seconds
    metric_aggregation_type = var.scale_down_metric_aggregation_type

    step_adjustment {
      metric_interval_upper_bound = var.scale_down_interval_upper_bound
      scaling_adjustment          = var.scale_down_adjustment
    }
  }

  depends_on = [
    aws_appautoscaling_target.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "alarm_high" {
  count               = var.enabled_cloudwatch_alarm ? 1 : 0
  alarm_name          = "${var.aws_metric_alarm_name}-${element(aws_ecs_service.this.*.name, count.index)}-High"
  alarm_description   = var.aws_alarm_description
  alarm_actions       = [aws_appautoscaling_policy.scale_up.*.arn[0]]
  comparison_operator = var.alarm_high_comparison_operator
  evaluation_periods  = var.alarm_high_evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.alarm_high_period
  statistic           = var.alarm_high_statistic
  threshold           = var.alarm_high_threshold

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = element(aws_ecs_service.this.*.name, count.index)
  }

  depends_on = [
    aws_appautoscaling_target.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "alarm_low" {
  count               = var.enabled_cloudwatch_alarm ? 1 : 0
  alarm_name          = "${var.aws_metric_alarm_name}-${element(aws_ecs_service.this.*.name, count.index)}-Low"
  alarm_description   = var.aws_alarm_description
  alarm_actions       = [aws_appautoscaling_policy.scale_down.*.arn[0]]
  comparison_operator = var.alarm_low_comparison_operator
  evaluation_periods  = var.alarm_low_evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.alarm_low_period
  statistic           = var.alarm_low_statistic
  threshold           = var.alarm_low_threshold

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = element(aws_ecs_service.this.*.name, count.index)
  }

  depends_on = [
    aws_appautoscaling_target.this
  ]
}
