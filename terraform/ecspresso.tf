resource "terraform_data" "ecspresso" {
  triggers_replace = [
    aws_ecs_cluster.app_ecs_cluster.name,
    module.ecs_task_execution_role.iam_role_arn
  ]

  provisioner "local-exec" {
    command     = "ecspresso deploy"
    working_dir = "."
    environment = {
      ECS_CLUSTER        = aws_ecs_cluster.app_ecs_cluster.name,
      EXECUTION_ROLE_ARN = module.ecs_task_execution_role.iam_role_arn,
      TARGET_GROUP_ARN   = aws_lb_target_group.app_tg.id
      IMAGE_TAG          = var.image_tag
    }
  }

  provisioner "local-exec" {
    command     = "ecspresso scale --tasks 0 && ecspresso delete --force"
    working_dir = "."
    when        = destroy
  }
}
