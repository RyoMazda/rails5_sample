// Ref:
// https://cross-black777.hatenablog.com/entry/2016/04/13/233208

resource "aws_db_subnet_group" "rails5-sample" {
  name        = "${local.tag}"
  description = "Allowed subnets for RDS cluster instances"

  subnet_ids = [
    "${aws_subnet.private-1.id}",
    "${aws_subnet.private-2.id}",
  ]

  tags {
    Name = "${local.tag}"
  }
}


resource "aws_db_parameter_group" "rails5-sample" {
  name = "${local.tag}"
  family = "postgres10"
  description = "${local.tag}"

  parameter {
    name = "log_min_duration_statement"
    value = "100"
  }
}


resource "aws_db_instance" "rails5-sample" {
  identifier = "${local.tag}"
  final_snapshot_identifier = "${local.tag}"
  allocated_storage = 20  // GB
  auto_minor_version_upgrade = true
  availability_zone = "${var.AWS_MAIN_AZ}"
  backup_retention_period = "7"  // days
  engine = "postgres"
  engine_version = "10.5"
  instance_class = "${local.rds_instance_class}"
  name = "${local.rds_name}"
  username = "${var.rds_master_username}"
  password = "${var.rds_master_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rails5-sample.name}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  parameter_group_name = "${aws_db_parameter_group.rails5-sample.name}"
  multi_az = false
  // storage_type = "general purpose (SSD)"
  backup_window = "04:00-05:00"
  apply_immediately = "true"

  tags {
    Name = "${local.tag}"
  }
}

output "rds_endpoint" {
  value = "${aws_db_instance.rails5-sample.address}"
}
