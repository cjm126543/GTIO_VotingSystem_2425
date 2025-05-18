// Create desired inbound rules
resource "aws_security_group_rule" "sql_in_rule" {
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = data.aws_security_group.default_sec_grp.id
  description       = "SQL Server in rule"
}

resource "aws_security_group_rule" "front_in_rule" {
  type              = "ingress"
  from_port         = 4200
  to_port           = 4200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default_sec_grp.id
  description       = "Frontend in rule"
}

resource "aws_security_group_rule" "back_in_rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = data.aws_security_group.default_sec_grp.id
  description       = "backend in rule"
}

resource "aws_security_group_rule" "kong_in_rule" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default_sec_grp.id
  description       = "kong in rule"
}

resource "aws_security_group_rule" "kongdb_in_rule" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default_sec_grp.id
  description       = "kongdb in rule"
}
