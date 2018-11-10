# ----------
# VPC
# ----------
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"         // default
  enable_dns_support   = "true"            // default
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"           // default

  tags {
    Name = "rails5-sample"
  }
}

# ----------
# Subnets
# ----------
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${lookup(var.subnet_cidrs, "public")}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_MAIN_AZ}"

  tags {
    Name = "rails5-sample"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${lookup(var.subnet_cidrs, "private-1")}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_MAIN_AZ}"

  tags {
    Name = "rails5-sample"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${lookup(var.subnet_cidrs, "private-2")}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_SUB_AZ}"

  tags {
    Name = "rails5-sample"
  }
}

# ----------
# Internet Gateway
# ----------
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "rails5-sample"
  }
}

# ----------
# Route Tables
# ----------
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "rails5-sample"
  }
}

# associations
resource "aws_route_table_association" "main-public-1a" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

# private subnetsはdefaultのroute tableでよい

# ----------
# Security Group
# ----------

# RDS
resource "aws_security_group" "rds" {
  name        = "RDS-sg-for-rails5-sample"
  description = "security group for RDS"
  vpc_id = "${aws_vpc.main.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags {
    Name = "rails5-sample"
  }
}

