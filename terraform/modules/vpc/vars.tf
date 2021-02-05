variable "create_vpc" {
  description = "Whether to create VPC or not."
  type        = bool
}

variable "aws_vpc_cidr" {
  description = "CIDR for the whole VPC"
}

variable "aws_vpc_name" {
  description = "What is your VPC name?"
  type        = string
}

variable "aws_environment" {
  description = "Which Environment does this VPC belong?"
  type        = string
}

variable "aws_description" {
  default = "Managed by Terraform. DO NOT change it manually."
}

variable "aws_availability_zones" {
  description = "Define the AWS AZ you want to deploy your stack"
  type        = list(string)
}

variable "public_subnet_cidr_all" {
  description = "List of Public Subnet CIDR"
  type        = list(string)
}

variable "create_private_subnet" {
  description = "Create Private Subnet or not"
  type        = bool
}

variable "private_subnet_cidr_all" {
  description = "List of Private Subnet CIDR"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

