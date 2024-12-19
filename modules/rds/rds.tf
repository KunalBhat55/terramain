resource "aws_db_instance" "main-db" {
  db_name             = "maindb"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  engine              = "postgres"
  publicly_accessible = true
  skip_final_snapshot = true
}
