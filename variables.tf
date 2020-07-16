variable "docker_compose_content" {
}

variable "iam_profile_name" {
  default = "bsx-cluster-instance"
}

variable "images" {
  type = list(string)
}

variable "registry_id" {
  default = "509581711139"
}

variable "registry_region" {
  default = "eu-central-1"
}

variable "registry_url" {
  default = "509581711139.dkr.ecr.eu-central-1.amazonaws.com"
}

variable "env" {
  default = "bsx"
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t3.micro"
}

variable "name" {
}

variable "rsa_public_key_name" {
  default = "bsx-bosix"
}

variable "sg_name" {
  default = "bsx-cluster-instance"
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "stack_version" {
}

variable "vpc_id" {
}

