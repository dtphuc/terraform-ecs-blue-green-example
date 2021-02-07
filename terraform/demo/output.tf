# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The Name of the VPC"
  value       = module.vpc.vpc_name
}

output "vpc_cidr_block" {
  description = "The CIDR block of VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = module.vpc.public_subnet_cidr_blocks
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = module.vpc.private_subnet_cidr_blocks
}

# Security groups
output "defaultSecGroup_Public" {
  description = "Initial Garden Default Security Group Public Access"
  value       = module.defaultSecGroup_Public.*.security_group_id
}

output "defaultSecGroup_PrivateOnly" {
  description = "Initial Garden Default Security Group with Egress All"
  value       = module.defaultSecGroup_PrivateOnly.*.security_group_id
}

# ALB Outputs
output "loadbalancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.demo_service.lb_dns_name
}

output "target_group_arns" {
  description = "ARNs of the target group."
  value       = module.demo_service.target_group_arns
}

# CodePipeline Outputs
output "ecr_repository_url" {
  description = "The ECR Repository URL"
  value       = module.demo_service.ecr_repository_url
}