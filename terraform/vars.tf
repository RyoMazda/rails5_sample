# ----------
# initial settings
# ----------
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "ap-northeast-1"
}
variable "AWS_MAIN_AZ" {
  default = "ap-northeast-1a"
}
variable "AWS_SUB_AZ" {
  default = "ap-northeast-1c"
}

locals {
  env = "${terraform.workspace}"
  name = "rails5-sample"

  tag = "${local.name}-${local.env}"
}


# ----------
# network
# ----------
locals {
  // vpc
  vpc_cidrs = {
    "stg" = "10.11.0.0/16"
    "prd" = "10.12.0.0/16"
  }
  vpc_cidr = "${lookup(local.vpc_cidrs, local.env)}"

  // subnet
  public_subnet_cidrs = {
    "stg" = "10.11.1.0/24"
    "prd" = "10.12.1.0/24"
  }
  public_subnet_cidr = "${lookup(local.public_subnet_cidrs, local.env)}"

  private1_subnet_cidrs = {
    "stg" = "10.11.10.0/24"
    "prd" = "10.12.10.0/24"
  }
  private1_subnet_cidr = "${lookup(local.private1_subnet_cidrs, local.env)}"

  private2_subnet_cidrs = {
    "stg" = "10.11.11.0/24"
    "prd" = "10.12.11.0/24"
  }
  private2_subnet_cidr = "${lookup(local.private2_subnet_cidrs, local.env)}"
}


# ----------
# RDS
# ----------
variable "rds_master_username" {}
variable "rds_master_password" {}

locals {
  rds_name = "pigidb"

  rds_instance_classes = {
    "stg" = "db.t2.small"
    "prd" = "db.t2.medium"
  }
  rds_instance_class = "${lookup(local.rds_instance_classes, local.env)}"
}


# ----------
# ECS
# ----------
locals {
  // ECR
  ecr_name_rails_app = "rails5-sample-${local.env}/rails-app"
  ecr_name_nginx = "rails5-sample-${local.env}/nginx"

  paths_to_public_key = {
    "stg" = "keys/mykey.pub"
    "prd" = "keys/mykey.pub"
  }
  path_to_public_key = "${lookup(local.paths_to_public_key, local.env)}"

  ecs_instance_types = {
    "stg" = "t2.micro"
    "prd" = "t2.small"
  }
  ecs_instance_type = "${lookup(local.ecs_instance_types, local.env)}"
}

variable "ecs_image_id" {
  type = "map"

  default = {
    ap-northeast-1 = "ami-08681de00a0aae54f"
    ap-southeast-1 = "ami-0a3f70f0255af1d29"
  }
}
