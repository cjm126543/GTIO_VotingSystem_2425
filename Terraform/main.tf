provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_security_group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.large"
  key_name      = var.key_name
  user_data     = base64encode(file("ecs_user_data.sh"))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_autoscaling_group" "ecs_instances" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

module "frontend" {
  source         = "./modules/service"
  name           = "front"
  container_port = 4200
  image          = "${var.ecr_repo_front}:latest"
  path           = "/alive"
  ecs_cluster_id = aws_ecs_cluster.main.id
  subnets        = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  sg_id          = aws_security_group.ecs_sg.id
  role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

module "backend" {
  source         = "./modules/service"
  name           = "back"
  container_port = 8080
  image          = "${var.ecr_repo_back}:latest"
  path           = "/alive"
  ecs_cluster_id = aws_ecs_cluster.main.id
  subnets        = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  sg_id          = aws_security_group.ecs_sg.id
  role_arn       = aws_iam_role.ecs_task_execution_role.arn
}