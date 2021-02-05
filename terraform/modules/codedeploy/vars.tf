variable "create_lb" {
  description = "Whether or not to create a load balancer"
  default     = true
  type        = bool
}

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

variable "ecs_cluster_name" {
  type        = string
  description = "The ECS Cluster name."
}

variable "ecs_service_name" {
  type        = string
  description = "The ECS Service name."
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
  default     = 5
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

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "service_role_arn" {
  type        = string
  description = "A CodeDeploy Service Role to be used"
  default     = ""
}