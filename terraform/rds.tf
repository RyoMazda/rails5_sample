// 参考:
// https://cross-black777.hatenablog.com/entry/2016/04/13/233208

resource "aws_db_subnet_group" "rails5-sample" {
  name        = "rails5-sample"
  description = "Allowed subnets for RDS cluster instances"

  subnet_ids = [
    "${aws_subnet.private-1.id}",
    "${aws_subnet.private-2.id}",
  ]

  tags {
    Name = "rails5-sample"
  }
}


resource "aws_db_parameter_group" "rails5-sample" {
  name = "rails5-sample"
  family = "postgres10"
  description = "rails5-sample"

  parameter {
    name = "log_min_duration_statement"
    value = "100"
  }
}


resource "aws_db_instance" "rails5-sample" {
  identifier = "rails5-sample"
  allocated_storage = 20  // GB
  auto_minor_version_upgrade = true
  availability_zone = "${var.AWS_MAIN_AZ}"
  backup_retention_period = "7"  // days
  engine = "postgres"
  engine_version = "10.5"
  instance_class = "${var.rds_instance_class}"
  name = "${var.rds_name}"
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
    Name = "rails5-sample"
  }
}

output "rds_endpoint" {
  value = "${aws_db_instance.rails5-sample.address}"
}

