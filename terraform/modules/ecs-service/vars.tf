variable "aws_region" {}
variable "aws_environment" {}
variable "create_ecs_service" {
  description = "Create ECS or not."
}
# variable "create_task_definition" {
#   description = "Create ECS Task Definition or not."
#   default     = true
# }

variable "aws_ecs_cluster_id" {
  type        = string
  description = "ARN of an ECS cluster"
}
variable "aws_ecs_task_name" {}
variable "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. Please note that you should only provide values that are part of the container definition document"
}
variable "ecs_service_name" {
  type        = string
  description = "The name of the service (up to 255 letters, numbers, hyphens, and underscores)"
}
variable "ecs_desired_count" {
  type        = string
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE"
  default     = 1
}

variable "cpu" {
  type        = string
  description = "The number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
}

variable "memory" {
  type        = string
  description = "The amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
}

variable "container_name" {
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)"
  type        = string
}
variable "target_group_index" {
  type        = string
  description = "(Required for ALB/NLB) The ARN of the Load Balancer target group to associate with the service."
}
variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE"
  default     = "EC2"
}
variable "container_port" {
  type        = string
  description = "The port on the container to associate with the load balancer."
}
variable "execution_role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
}

variable "task_role_arn" {
  type        = string
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}
variable "subnets" {
  description = "The subnets associated with the task or service."
}
variable "security_groups" {
  type = list(string)
}
variable "deployment_max_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
}
variable "deployment_min_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
}
variable "enabled_autoscale" {
  description = "Enable App Autoscaling"
}
variable "autoscale_policy_name" {
  description = "The Policy Name"
}

variable "max_capacity" {
  description = "The max capacity of the scalable target."
}

variable "min_capacity" {
  description = "The min capacity of the scalable target."
}
variable "ecs_cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "app_autoscale_role" {
  description = "The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf."
}

variable "scalable_dimension" {
  description = "The scalable dimension of the scalable target."
}
variable "service_namespace" {}

variable "policy_type" {
  description = "The policy type for App Autoscaling."
  default     = "StepScaling"
}

variable "adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity."
}
variable "scale_up_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "scale_down_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}
variable "scale_up_metric_aggregation_type" {
  description = "The aggregation type for the policy's metrics. Valid values are Minimum, Maximum, and Average. Without a value, AWS will treat the aggregation type as Average."
}

variable "scale_down_metric_aggregation_type" {
  description = "The aggregation type for the policy's metrics. Valid values are Minimum, Maximum, and Average. Without a value, AWS will treat the aggregation type as Average."
}
variable "scale_up_interval_lower_bound" {
  description = " The lower bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as negative infinity."
}
variable "scale_down_interval_upper_bound" {
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound."
}
variable "scale_up_adjustment" {
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down."
}

variable "scale_down_adjustment" {
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down."
}

variable "enabled_cloudwatch_alarm" {
  description = "Enable CloudWatch Metric Alarm"
}
variable "aws_metric_alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account"
}
variable "aws_alarm_description" {
  description = "The description for the alarm."
}
variable "alarm_high_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
}
variable "alarm_high_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "namespace" {
  description = "The namespace for the alarm's associated metric"
}
variable "metric_name" {
  description = "The name for the alarm's associated metric"
}
variable "alarm_high_period" {
  description = "The period in seconds over which the specified statistic is applied."
}
variable "alarm_high_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
}
variable "alarm_high_threshold" {
  description = "The value against which the specified statistic is compared."
}
variable "alarm_low_comparison_operator" {}
variable "alarm_low_evaluation_periods" {}
variable "alarm_low_period" {}
variable "alarm_low_statistic" {}
variable "alarm_low_threshold" {}




