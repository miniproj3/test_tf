resource "aws_instance" "tf_bastion" {
  ami           = "ami-0a20b1b99b215fb27" # Amazon Linux 2 AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.tf_pub_sub_1.id
  key_name      = aws_key_pair.tf_bastion_key.key_name
  vpc_security_group_ids = [aws_security_group.tf_bastion_sg.id]
  associate_public_ip_address = true
  
  depends_on = [aws_key_pair.tf_bastion_key]

  tags = {
    Name = "bastion"
  }
}
