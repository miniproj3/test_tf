resource "aws_route_table" "tf_pri_rtb" {
  vpc_id = aws_vpc.tf_vpc.id

  /* route {  # route 추가
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat.id
  } */

  tags = {
    Name = "tf_pri_rtb"
  }
}

resource "aws_route" "tf_pri_route_nat" {   # 위에 route와 동일한 방식
  route_table_id = aws_route_table.tf_pri_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.tf_nat.id
}

resource "aws_route_table_association" "tf_pri_sub_1_association" {
  subnet_id      = aws_subnet.tf_pri_sub_1.id
  route_table_id = aws_route_table.tf_pri_rtb.id
}

resource "aws_route_table_association" "tf_pri_sub_2_association" {
  subnet_id      = aws_subnet.tf_pri_sub_2.id
  route_table_id = aws_route_table.tf_pri_rtb.id
}

resource "aws_route_table_association" "tf_rds_sub_1_association" {
  subnet_id      = aws_subnet.tf_rds_sub_1.id
  route_table_id = aws_route_table.tf_pri_rtb.id
}

resource "aws_route_table_association" "tf_rds_sub_2_association" {
  subnet_id      = aws_subnet.tf_rds_sub_2.id
  route_table_id = aws_route_table.tf_pri_rtb.id
}
