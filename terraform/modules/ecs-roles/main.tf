/*
* IAM ECS Task role
*/
data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}
resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_task_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceRole" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

/* role that the Amazon ECS container agent and the Docker daemon can assume */

/*
* IAM ECS Task Execution role
*/
data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy" "ecs_execution_policy" {
  name   = "ecs_task_execution_policy"
  policy = file("${path.module}/../../templates/ecs_roles/ecs_task_execution_policy.json")
  role   = aws_iam_role.ecs_task_execution_role.id
}