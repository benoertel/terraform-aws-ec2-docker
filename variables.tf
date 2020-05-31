variable "iam_profile_name" {
  default = "bsx-cluster-instance"
}

variable "images" {
  type = "list"
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

variable "name" {}

variable "rsa_public_key_name" {
  default = "bsx-bosix"
}

variable "sg_name" {
  default = "bsx-cluster-instance"
}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "stack_version" {}

variable "vpc_id" {}
