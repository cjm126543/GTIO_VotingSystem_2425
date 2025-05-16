resource "aws_db_instance" "microsoft_sql_db" {
  identifier              = "my-db-instance"
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.4430.1.v1"
  instance_class          = "db.t3.small"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "admin"
  password                = "M1c0ntr4s3n4"
  //db_name                 = "my_rds_db"
  vpc_security_group_ids  = [data.aws_security_group.default_sec_grp.id]
  //db_subnet_group_name    = data.aws_vpc.default_vpc.id
  multi_az                = false
  publicly_accessible     = false
  backup_retention_period = 7

  tags = {
    Environment = "test"
    Project     = "gtio-ot-voting"
  }
}