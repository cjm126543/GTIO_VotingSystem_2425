resource "aws_ecs_task_definition" "task_custom" {
  family                   = var.task_family_name
  requires_compatibilities = ["EC2"]
  network_mode            = "awsvpc"
  cpu                     = "850"
  memory                  = "850"
  task_role_arn           = var.labrole_arn
  execution_role_arn      = var.labrole_arn

  container_definitions = jsonencode([
    {
      name      = var.container_definition_name
      image     = var.container_image_uri
      essential = true

      portMappings = [
        {
          containerPort = var.container_ports[0]
          hostPort      = var.container_ports[1]
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.awslogs_group
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  lifecycle {
    create_before_destroy = true
    ignore_changes = [revision]
  }

}