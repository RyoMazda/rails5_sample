# ----------
# ECR
# ----------
resource "aws_ecr_repository" "rails-app" {
  name = "${local.ecr_name_rails_app}"
}

resource "aws_ecr_repository" "nginx" {
  name = "${local.ecr_name_nginx}"
}

output "ecr-repository-URL-rails-app" {
  value = "${aws_ecr_repository.rails-app.repository_url}"
}

output "ecr-repository-URL-nginx" {
  value = "${aws_ecr_repository.nginx.repository_url}"
}

# ----------
# Key for ssh (for debug)
# ----------
resource "aws_key_pair" "ecs-key" {
  key_name   = "${local.tag}-ecs-key"
  public_key = "${file("${local.path_to_public_key}")}"

  lifecycle {
    ignore_changes = ["public_key"]
  }
}

# ----------
# Cluster
# ----------
resource "aws_ecs_cluster" "rails5-sample" {
  name = "${local.tag}"
}

# Auto Scaling for ECS cluster
resource "aws_launch_configuration" "rails5-sample" {
  name_prefix          = "${local.tag}"
  image_id             = "${lookup(var.ecs_image_id, var.AWS_REGION)}"
  instance_type        = "${local.ecs_instance_type}"
  key_name             = "${aws_key_pair.ecs-key.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-ec2-instance.id}"
  security_groups      = ["${aws_security_group.ecs-ec2-instance.id}"]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=${aws_ecs_cluster.rails5-sample.name}' > /etc/ecs/ecs.config\nstart ecs"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rails5-sample" {
  name                 = "${local.tag}"
  vpc_zone_identifier  = ["${aws_subnet.public.id}"]
  launch_configuration = "${aws_launch_configuration.rails5-sample.name}"
  min_size             = 1
  max_size             = 1

  tag {
    key                 = "Name"
    value               = "${local.tag}"
    propagate_at_launch = true
  }
}

# ----------
# Task Definision
# ----------
data "template_file" "rails5-sample" {
  template = "${file("container_definition.json")}"

  vars {
    NGINX_REPOSITORY_URL = "${replace("${aws_ecr_repository.nginx.repository_url}", "https://", "")}"
    RAILS_APP_REPOSITORY_URL = "${replace("${aws_ecr_repository.rails-app.repository_url}", "https://", "")}"
    DB_HOST = "${aws_db_instance.rails5-sample.address}"
    DB_USERNAME = "${var.rds_master_username}"
    DB_PASSWORD = "${var.rds_master_password}"
  }
}

resource "aws_ecs_task_definition" "rails5-sample" {
  family                = "${local.tag}"
  container_definitions = "${data.template_file.rails5-sample.rendered}"

  volume {
    name = "static-content"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
    }
  }
  volume {
    name = "sock-to-app"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
    }
  }
}

# ----------
# Service
# ----------
# without ELB
resource "aws_ecs_service" "rails5-sample" {
  name            = "${local.tag}"
  cluster         = "${aws_ecs_cluster.rails5-sample.id}"
  task_definition = "${aws_ecs_task_definition.rails5-sample.arn}"
  desired_count   = 1
}
