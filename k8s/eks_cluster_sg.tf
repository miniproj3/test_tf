# 클러스터 보안그룹
resource "aws_security_group" "tf_eks_cluster_sg" {
  name        = "tf-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = aws_vpc.tf_vpc.id
  
  # Bastion → EKS API 서버 (kubectl 사용)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow bastion to communicate with the cluster API"
    security_groups = [aws_security_group.tf_bastion_sg.id]
  }

  # Worker Nodes → EKS Control Plane (노드 → 클러스터)
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    description = "Allow worker nodes to communicate with the cluster"
    self = true  # 같은 보안 그룹 내부에서 통신 가능
  }

  # DNS 요청 허용 (CoreDNS)
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    description = "Allow worker nodes to use DNS (UDP)"
    self = true
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    description = "Allow worker nodes to use DNS (TCP)"
    self = true
  }

  # EKS Control Plane → 노드 (클러스터 → 노드)
  egress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    description = "Allow cluster to communicate with worker nodes"
    self = true
  }

  # EKS 클러스터 → 인터넷 (ECR, S3, 외부 API 호출 등)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow cluster to communicate with AWS services"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS 요청 허용 (외부 도메인 조회)
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    description = "Allow DNS resolution"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_eks_cluster_sg"
  }
}
