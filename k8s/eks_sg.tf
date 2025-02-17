# 클러스터 보안그룹
resource "aws_security_group" "tf_eks_cluster_sg" {
  name        = "tf-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = aws_vpc.tf_vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow bastion to communicate with the cluster API"
    security_groups = [aws_security_group.tf_bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_eks_cluster_sg"
  }
}
