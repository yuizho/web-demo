# ECS
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app"
}

resource "aws_ecs_task_definition" "app_ecs_task_definition" {
  family                   = "app"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

resource "aws_ecs_service" "app_ecs_service" {
   name                              = "app-ecs-service"
   cluster                           = aws_ecs_cluster.app_ecs_cluster.arn
   task_definition                   = aws_ecs_task_definition.app_ecs_task_definition.arn
   desired_count                     = 2
   launch_type                       = "FARGATE"
   platform_version                  = "1.4.0"
   health_check_grace_period_seconds = 60

   network_configuration {
     assign_public_ip = false
     security_groups  = [module.tomcat_internal_sg.security_group_id]

    subnets = [
      aws_subnet.app_subnet_private["ap-northeast-1a"].id,
      aws_subnet.app_subnet_private["ap-northeast-1c"].id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app-container"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
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
