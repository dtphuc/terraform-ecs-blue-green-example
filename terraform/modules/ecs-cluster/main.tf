# Create ECS Cluster
resource "aws_ecs_cluster" "this" {
  count              = var.create_ecs_cluster ? 1 : 0
  name               = var.ecs_cluster_name
  tags = merge(
    {
      "Name" = var.ecs_cluster_name
    },
    var.tags
  )

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
  lifecycle {
    create_before_destroy = true
  }
}