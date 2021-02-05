# Create ECS Cluster
module "ecs_cluster" {
  source             = "../modules/ecs-cluster"
  create_ecs_cluster = true
  aws_environment    = var.aws_environment
  ecs_cluster_name   = var.ecs_cluster_name
  container_insights = true
  tags = {
    "ManagedBy"   = "Terraform"
    "Environment" = var.aws_environment
    "Function"    = "ECSCluster"
  }
}

