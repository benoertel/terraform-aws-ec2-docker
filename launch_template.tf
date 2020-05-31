data "template_file" "userdata_pull_images" {
  count = "${length(var.images)}"

  template = "${file("${path.module}/data/userdata_pull_images.sh.tpl")}"

  vars {
    image_name      = "${replace(element(var.images, count.index), "/:.*/", "")}"
    image_tag       = "${replace(replace(element(var.images, count.index), replace(element(var.images, count.index), "/:.*/", ""), ""), "/^:/", "")}"
    registry_url    = "${var.registry_url}"
    registry_region = "${var.registry_region}"
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/data/userdata.sh.tpl")}"

  vars {
    docker_compose_content = "${var.docker_compose_content}"
    registry_id            = "${var.registry_id}"
    userdata_pull_images   = "${join("\n", data.template_file.userdata_pull_images.*.rendered)}"
  }
}

resource "aws_launch_template" "instance" {
  image_id                             = "${data.aws_ami.bosix_docker.id}"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "${var.instance_type}"
  key_name                             = "${var.rsa_public_key_name}"
  name                                 = "${local.name_with_prefix}"
  user_data                            = "${base64encode(data.template_file.userdata.rendered)}"

  vpc_security_group_ids = ["${data.aws_security_group.cluster_instance.id}"]

  iam_instance_profile {
    arn = "${data.aws_iam_instance_profile.cluster_instance.arn}"
  }

  tag_specifications {
    resource_type = "volume"

    tags {
      Env          = "${var.env}"
      ManagedBy    = "Terraform"
      Name         = "${local.name_with_prefix}"
      StackVersion = "${var.stack_version}"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags {
      Env          = "${var.env}"
      ManagedBy    = "Terraform"
      Name         = "${local.name_with_prefix}"
      StackVersion = "${var.stack_version}"
    }
  }

  tags {
    Env          = "${var.env}"
    ManagedBy    = "Terraform"
    Name         = "${local.name_with_prefix}"
    StackVersion = "${var.stack_version}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
