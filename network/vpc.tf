resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default" # 테넌시 : 기본값

  tags = {
    Name = "tf_vpc"
  }
}
