data "aws_subnet_ids" "cluster" {
  vpc_id = var.vpc_id
}

resource "aws_autoscaling_group" "instance" {
  launch_template = {
    id      = aws_launch_template.instance.id
    version = aws_launch_template.instance.latest_version
  }

  max_size                  = var.instance_count
  min_size                  = var.instance_count
  name                      = "${local.name_with_prefix}/${aws_launch_template.instance.id}/${aws_launch_template.instance.latest_version}"
  vpc_zone_identifier       = [data.aws_subnet_ids.cluster.ids]
  wait_for_capacity_timeout = "30m"

  initial_lifecycle_hook {
    heartbeat_timeout    = 30 * 60
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    name                 = "docker_ready"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = false
  }

  tag {
    key                 = "Env"
    propagate_at_launch = false
    value               = var.env
  }
}
