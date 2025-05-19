// Crear una definición de tarea para cada cluster
resource "aws_ecs_task_definition" "task_kong" {
  family                   = var.task_family_name
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "850"
  memory                   = "850"
  task_role_arn            = var.labrole_arn
  execution_role_arn       = var.labrole_arn

  container_definitions = jsonencode([
    {
      name      = "db"
      image     = "postgres:13-alpine"
      essential = true
      environment = [
        { name = "POSTGRES_USER", value = "kong" },
        { name = "POSTGRES_PASSWORD", value = "kong" },
        { name = "POSTGRES_DB", value = "kong" }
      ],
      portMappings = [
        { containerPort = 5432, hostPort = 5432 }
      ],
      //healthCheck = {
      //  command     = ["CMD-SHELL", "pg_isready -U kong"]
      //  interval    = 10
      //  timeout     = 5
      //  retries     = 5
      //  startPeriod = 10
      //}

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.awslogs_group,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = var.container_definition_name
      image     = var.container_image_uri
      essential = true
      portMappings = [
        { containerPort = 8000, hostPort = 8000 }
      ],
      dependsOn = [
        {
          containerName = "db",
          condition     = "START"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.awslogs_group,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])


  lifecycle {
    create_before_destroy = true
    ignore_changes        = [revision]
  }
}