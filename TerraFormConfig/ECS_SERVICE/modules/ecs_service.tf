resource "aws_ecs_service" "ecs_service" {
  // Service details
  task_definition = "${var.task_family_name}"
  name            = var.service_name
  cluster         = var.cluster_id

  // Environment
    // Nullified means the default capacity provider strategy

  // Deployment configuration
  deployment_controller {
    type = "ECS"
  }
  desired_count   = 1
    // Availability zone rebalancing activated in aws_autoscaling_group by default
  health_check_grace_period_seconds = 30

  // Networking
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }

  // Load balancing
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  // Tags propagation
  enable_ecs_managed_tags           = true
  propagate_tags                    = "SERVICE"

  // Depends on listener
  depends_on = [var.alb_listener]
}
