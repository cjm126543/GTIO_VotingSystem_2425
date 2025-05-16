resource "aws_ecr_repository" "carlos_repo" {
  name = "carlos/repo"

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "test"
    Project     = "gtio-ot-voting"
  }
}