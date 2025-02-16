resource "aws_db_instance" "tf_rds" {
  allocated_storage    = 20
  db_name              = "testdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "testpass"
  multi_az             = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.vss_rds_subnet_group.name
  skip_final_snapshot  = true

  storage_type = "gp3" # 범용 SSD
  
  tags = {
    Name = "tf_rds"
  }
}
