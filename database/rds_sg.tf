# RDS 보안 그룹
resource "aws_security_group" "tf_rds_sg" {
  name        = "tf_rds_sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.vss_vpc.id

  # EKS 클러스터 및 VPC 내부에서의 접근 허용
  #ingress {
  #  description      = "Allow access from VPC internal subnets"
  #  from_port        = 3306
  #  to_port          = 3306
  #  protocol         = "tcp"
  #  cidr_blocks      = [aws_vpc.tf_vpc.cidr_block]
  #}

  # 관리 목적으로 Bastion Host에서 접근 허용 (필요 시)
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.tf_bastion_sg.id]
  }

  # RDS의 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_rds_sg"
  }
}
