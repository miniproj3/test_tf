resource "aws_eip" "tf_eip" {
  domain = "vpc"
  
  tags = {
    Name = "tf_eip"
  }
}

resource "aws_nat_gateway" "tf_nat" {
  allocation_id = aws_eip.tf_eip.allocation_id
  subnet_id     = aws_subnet.tf_pub_sub_2.id
  depends_on = [aws_eip.tf_eip]

  tags = {
    Name = "tf_nat"
  }
}
