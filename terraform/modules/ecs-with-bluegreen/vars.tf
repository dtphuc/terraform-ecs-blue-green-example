# ALB Variables
variable "create_alb" {
  description = "Controls if the ALB should be created"
  type        = bool
  default     = true
}

variable "aws_environment" {
  description = "Which Environment does this VPC belong?"
  type        = string
}

variable "target_group_tags" {
  description = "A map of tags to add to all target groups"
  type        = map(string)
  default     = {}
}

variable "lb_security_groups" {
  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
  type        = list(string)
  default     = []
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "aws_alb_subnet_ids" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = list(string)
  default     = null
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type        = any
  default     = []
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type        = any
  default     = []
}

variable "load_balancer_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "load_balancer_is_internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = false
}

variable "lb_tags" {
  description = "A map of tags to add to load balancer"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the stack"
  default     = "ap-southeast-1"
}

# ECS Variables
variable "create_ecs_service" {
  description = "Create ECS or not."
  type        = string
  default     = true
}

variable "aws_ecs_cluster_id" {
  type        = string
  description = "ARN of an ECS cluster"
}
variable "aws_ecs_task_name" {
  type        = string
  description = "AWS ECS Task Name"
}

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
  default     = 256
}

variable "memory" {
  type        = string
  description = "The amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 512
}

variable "container_name" {
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)"
  type        = string
}

variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE"
  default     = "EC2"
}
variable "container_port" {
  type        = string
  description = "The port on the container to associate with the load balancer."
  default     = 80
}
variable "execution_role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
}

variable "task_role_arn" {
  type        = string
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}
variable "ecs_subnet_ids" {
  type        = list(string)
  description = "The subnets associated with the task or service."
}

variable "ecs_security_groups" {
  type        = list(string)
  description = "The security groups associated with the task or service."
}

variable "deployment_max_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = string
  default     = 200
}
variable "deployment_min_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = string
  default     = 100
}

variable "enabled_autoscale" {
  description = "Enable App Autoscaling"
  type        = string
  default     = true
}
variable "autoscale_policy_name" {
  description = "The Policy Name"
  type        = string
  default     = "autoscale-policy"
}

variable "max_capacity" {
  description = "The max capacity of the scalable target."
  type        = string
  default     = 2
}

variable "min_capacity" {
  description = "The min capacity of the scalable target."
  type        = string
  default     = 1
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "app_autoscale_role" {
  description = "The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf."
  type        = string
  default     = "arn:aws:iam::159965030913:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

variable "scalable_dimension" {
  description = "The scalable dimension of the scalable target."
  type        = string
  default     = "ecs:service:DesiredCount"
}
variable "service_namespace" {
  description = "Service namespace for app autoscaling"
  type        = string
  default     = "ecs"
}

variable "policy_type" {
  description = "The policy type for App Autoscaling."
  default     = "StepScaling"
}

variable "adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity."
  default     = "ChangeInCapacity"
}

variable "scale_up_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = "300"
}

variable "scale_down_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = "300"
}

variable "scale_up_metric_aggregation_type" {
  description = "The aggregation type for the policy's metrics. Valid values are Minimum, Maximum, and Average. Without a value, AWS will treat the aggregation type as Average."
  default     = "Average"
}

variable "scale_down_metric_aggregation_type" {
  description = "The aggregation type for the policy's metrics. Valid values are Minimum, Maximum, and Average. Without a value, AWS will treat the aggregation type as Average."
  default     = "Average"
}

variable "scale_up_interval_lower_bound" {
  description = " The lower bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as negative infinity."
  default     = "0"
}

variable "scale_down_interval_upper_bound" {
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity. The upper bound must be greater than the lower bound."
  default     = 0
}
variable "scale_up_adjustment" {
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down."
  default     = 1
}

variable "scale_down_adjustment" {
  description = "The number of members by which to scale, when the adjustment bounds are breached. A positive value scales up. A negative value scales down."
  default     = -1
}

variable "enabled_cloudwatch_alarm" {
  description = "Enable CloudWatch Metric Alarm"
  type        = string
  default     = true
}
variable "aws_metric_alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account"
  type        = string
  default     = "aws_metric_alarm"
}
variable "aws_alarm_description" {
  description = "The description for the alarm."
  type        = string
  default     = "CloudWatch Alarm for ECS Service"
}
variable "alarm_high_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}
variable "alarm_high_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = string
  default     = "1"
}
variable "namespace" {
  description = "The namespace for the alarm's associated metric"
  type        = string
  default     = "AWS/ECS"
}
variable "metric_name" {
  description = "The name for the alarm's associated metric"
  type        = string
  default     = "CPUUtilization"
}
variable "alarm_high_period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = string
  default     = 60
}
variable "alarm_high_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type        = string
  default     = "Average"
}

variable "alarm_high_threshold" {
  description = "The value against which the specified statistic is compared."
  type        = string
  default     = 75
}

variable "alarm_low_comparison_operator" {
  default = "LessThanOrEqualToThreshold"
}
variable "alarm_low_evaluation_periods" {
  default = 3
}
variable "alarm_low_period" {
  default = 60
}
variable "alarm_low_statistic" {
  default = "Average"
}
variable "alarm_low_threshold" {
  default = 30
}

# CodeDeploy variables
variable "create_app" {
  description = "Whether to create the CodeDeploy Application"
  default     = true
  type        = bool
}

variable "ca_application_name" {
  default     = ""
  type        = string
  description = "The name of the application."
}

variable "deployment_group_name" {
  description = "Name of the codedeploy deployment group to create"
  type        = string
  default     = ""
}

variable "deployment_config_name" {
  description = "Name of the codedeploy config to use with deployment group"
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "deployment_option" {
  description = "Route deployment traffic through a load balancer?"
  default     = "WITH_TRAFFIC_CONTROL"
}

variable "deployment_type" {
  description = "In-place or Blue/Green deployment"
  default     = "BLUE_GREEN"
}

variable "auto_rollback" {
  default     = true
  type        = string
  description = "Indicates whether a defined automatic rollback configuration is currently enabled for this Deployment Group."
}

variable "rollback_events" {
  default     = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  type        = list(string)
  description = "The event type or types that trigger a rollback."
}

variable "action_on_timeout" {
  default     = "CONTINUE_DEPLOYMENT"
  type        = string
  description = "When to reroute traffic from an original environment to a replacement environment in a blue/green deployment."
}

variable "wait_time_in_minutes" {
  default     = 0
  type        = string
  description = "The number of minutes to wait before the status of a blue/green deployment changed to Stopped if rerouting is not started manually."
}

variable "termination_wait_time_in_minutes" {
  default     = 15
  type        = string
  description = "The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment."
}

variable "load_balancer_info" {
  type        = list(map(string))
  description = "The load balancer info. Can be one or more"
  default     = []
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "codedeploy_tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "codedeploy_service_role_arn" {
  type        = string
  description = "A CodeDeploy Service Role to be used"
  default     = ""
}

