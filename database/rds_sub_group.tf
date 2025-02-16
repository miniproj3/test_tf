resource "aws_db_subnet_group" "tf_rds_subnet_group" {
  name       = "tf_rds_subnet_group"
  subnet_ids = [aws_subnet.rds_pri_sub[1].id, aws_subnet.rds_pri_sub[2].id]

  tags = {
    Name = "tf_rds_subnet_group"
  }
}
