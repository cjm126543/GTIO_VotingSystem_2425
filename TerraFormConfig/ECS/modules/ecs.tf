# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.custom_cp.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.custom_cp.name
    weight            = 1
    base              = 1
  }
}

# Launch Template para EC2
resource "aws_launch_template" "ecs_instance_template" {
  name_prefix   = var.ecs_prefix
  image_id      = var.aws_ami_id
  instance_type = "t2.micro"
  key_name      = "vockey" # debe existir este par de claves en tu cuenta
  iam_instance_profile {
    name = "LabInstanceProfile" # debe existir o lo creas por separado
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups = [
      var.security_group_id
    ]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }
user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
)
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  name     = var.asg_name
  max_size = 1
  min_size = 1
  //desired_capacity = 1
  vpc_zone_identifier = var.aws_subnets_ids

  launch_template {
    id      = aws_launch_template.ecs_instance_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.tag_name
    propagate_at_launch = true
  }
}

# Capacity provider
resource "aws_ecs_capacity_provider" "custom_cp" {
  name = var.capacity_provider_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}
