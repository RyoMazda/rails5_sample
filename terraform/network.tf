# ----------
# VPC
# ----------
resource "aws_vpc" "main" {
  cidr_block           = "${local.vpc_cidr}"
  instance_tenancy     = "default"         // default
  enable_dns_support   = "true"            // default
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"           // default

  tags {
    Name = "${local.tag}"
  }
}

# ----------
# Subnets
# ----------
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${local.public_subnet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_MAIN_AZ}"

  tags {
    Name = "${local.tag}"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${local.private1_subnet_cidr}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_MAIN_AZ}"

  tags {
    Name = "${local.tag}"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${local.private2_subnet_cidr}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_SUB_AZ}"

  tags {
    Name = "${local.tag}"
  }
}

# ----------
# Internet Gateway
# ----------
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${local.tag}"
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
    Name = "${local.tag}"
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

# ECS
resource "aws_security_group" "ecs-ec2-instance" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${local.tag}"
  description = "security group for ecs"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${local.tag}"
  }
}

# RDS
resource "aws_security_group" "rds" {
  name        = "RDS-sg-for-${local.tag}"
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
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  tags {
    Name = "${local.tag}"
  }
}

