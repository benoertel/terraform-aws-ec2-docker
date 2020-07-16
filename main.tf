data "aws_ami" "bosix_docker" {
  most_recent = true
  owners      = [var.registry_id]

  filter {
    name   = "name"
    values = ["Bosix-Docker_*"]
  }
}

data "aws_security_group" "cluster_instance" {
  name = var.sg_name
}

data "aws_iam_instance_profile" "cluster_instance" {
  name = var.iam_profile_name
}

