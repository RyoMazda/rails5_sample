# ----------------------
# S3にtfstate置く設定
# ----------------------
terraform {
  required_version = ">= 0.11.0"

  backend "s3" {  # backend段階では変数使えない!!!!!
    bucket = "terraform-state-lecsum"
    key = "rails5_sample.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "${var.AWS_REGION}"
}

