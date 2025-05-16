# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Launch Template para EC2
resource "aws_launch_template" "ecs_instance_template" {
  name_prefix   = var.ecs_prefix
  image_id      = var.aws_ami_id
  instance_type = "t3.micro"
  key_name      = "vockey" # debe existir este par de claves en tu cuenta
  iam_instance_profile {
    name = "LabInstanceProfile" # debe existir o lo creas por separado
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  name     = var.asg_name
  max_size = 1
  min_size = 1
  //desired_capacity          = 1
  vpc_zone_identifier = var.aws_subnets_ids

  launch_template {
    id      = aws_launch_template.ecs_instance_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.tag_name
    propagate_at_launch = true
  }
}