# VPC Variables
variable "create_vpc" {
  description = "Whether to create VPC or not."
  type        = bool
  default     = true
}

# Use this data source to get the access to Account ID, User ID and ARN in 
# which Terraform is authorized.
data "aws_caller_identity" "current" {}

variable "aws_region" {
  type        = string
  description = "(optional) describe your variable"
  default     = "us-east-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS environment name"
  default     = "dev"
}

variable "aws_vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "aws_vpc_name" {
  description = "What is your VPC name?"
  type        = string
  default     = "demo"
}

variable "aws_availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidr_all" {
  description = "List of Public Subnet CIDR"
  type        = list(string)
  default     = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "create_private_subnet" {
  description = "Create Private Subnet or not"
  type        = bool
  default     = true
}

variable "private_subnet_cidr_all" {
  description = "List of Private Subnet CIDR"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

#################
# Security group variables
#################
variable "create_security_groups" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. Enable for EMR."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default = {
    "Function"  = "BastionHost"
    "ManagedBy" = "Terraform"
  }
}

##########
# Ingress
##########

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "default_secgroups_public_ingress_rules" {
  type        = list(map(string))
  description = "List of ingress rules for Default Security Group Public to create"
  default = [
    {
      from_port : 80
      to_port : 80
      protocol : "tcp"
      description : "Allow HTTP Access. Please DO NOT CHANGE MANUALLY!!"
    },
    {
      from_port : 8080
      to_port : 8080
      protocol : "tcp"
      description : "Allow HTTP Access. Please DO NOT CHANGE MANUALLY!!"
    },
    {
      from_port : 443
      to_port : 443
      protocol : "tcp"
      description : "Allow HTTPS Access. Please DO NOT CHANGE MANUALLY!!"
    },
  ]
}

variable "default_secgroups_public_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#########
# Egress
#########
variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "default_secgroups_public_egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(map(string))
  default = [
    {
      from_port : 0
      to_port : 0
      protocol : "-1"
      description : "Allow All outbound. Please DO NOT CHANGE MANUALLY!!"
    }
  ]
}

# IAM Roles
variable "ecs_task_role" {
  type        = string
  description = "ECS Service Task Role name"
  default     = "managed_ecs_task_role"
}

variable "ecs_task_execution_role" {
  type        = string
  description = "ECS Service Role name"
  default     = "managed_ecs_task_execution_role"
}

variable "iam_role_name" {
  type        = string
  description = "IAM Role name"
  default     = "managed_ecs_role"
}

variable "ecs_codedeploy_roles" {
  type    = string
  default = "managed_ecs_codedeploy_role"
}

# ECS
variable "ecs_cluster_name" {
  type        = string
  description = "The ECS Cluster name"
  default     = "demo-ecs-cluster"
}

variable "ecs_service_role" {
  type        = string
  description = "ECS Service Role name"
  default     = "managed_ecs_service_roles"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS Service name"
  default     = "demo-service"
}

variable "container_name" {
  type        = string
  description = "Container Name"
  default     = "demo-app"
}

variable "container_port" {
  type        = string
  description = "Container port"
  default     = 80
}

# Values can be:
/*
* CodeDeployDefault.ECSLinear10PercentEvery1Minutes
* CodeDeployDefault.ECSLinear10PercentEvery3Minutes 
* CodeDeployDefault.ECSCanary10Percent5Minutes
* CodeDeployDefault.ECSCanary10Percent15Minutes
* CodeDeployDefault.ECSAllAtOnce (Default)
*/
variable "deployment_config_name" {
  description = "Name of the codedeploy config to use with deployment group"
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

# S3
variable "s3_bucket_name" {
  type    = string
  default = "demo-app-codepipeline"
}