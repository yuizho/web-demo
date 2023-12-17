# ECS
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app"
}

resource "aws_appautoscaling_target" "app_autoscaling_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app_ecs_cluster.name}/app-ecs-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on = [
    terraform_data.ecspresso
  ]
}

resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "/ecs/app"
  retention_in_days = 180
}

# IAM
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# docker pullに必要
data "aws_iam_policy" "container_registry_readonly_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_policy_documents = [
    data.aws_iam_policy.ecs_task_execution_role_policy.policy,
    data.aws_iam_policy.container_registry_readonly_policy.policy
  ]

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source     = "./iam_role"
  name       = "app-ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}
