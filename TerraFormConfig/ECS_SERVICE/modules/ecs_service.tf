resource "aws_ecs_service" "ecs_service" {
  name            = var.task_family
  cluster         = data.aws_ecs_cluster.cluster.id
  task_definition = "${data.aws_ecs_task_definition.task.family}:${data.aws_ecs_task_definition.task.revision}"
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = 30
  enable_ecs_managed_tags           = true
  propagate_tags                    = "SERVICE"

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }

  depends_on = [data.aws_lb_listener.http]
}
