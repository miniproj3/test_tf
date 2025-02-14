resource "tls_private_key" "tf_bastion_key" {
  algorithm   = "RSA"
}

resource "local_file" "tf_bastion_private_key" {
  content  = tls_private_key.tf_bastion_key.private_key_pem
  filename = "/home/terraform/tf-bastion-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "tf_bastion_key" {
  key_name   = "tf-bastion-key"
  public_key = tls_private_key.tf_bastion_key.public_key_openssh 

  tags = {
    Name = "tf_bastion_key"
  }
}
