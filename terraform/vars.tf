# ----------
# 初期設定
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

# ----------
# network
# ----------
variable "vpc_cidr" {
  default = "10.11.0.0/16"
}

variable "subnet_cidrs" {
  type = "map"

  default = {
    "public"    = "10.11.1.0/24"
    "private-1" = "10.11.10.0/24"
    "private-2" = "10.11.11.0/24"
  }
}
