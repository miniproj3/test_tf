# EKS 노드 그룹 보안 그룹
resource "aws_security_group" "tf_eks_node_group_sg" {
  name        = "tf-eks-node-group-sg"
  description = "EKS Node Group Security Group"
  vpc_id      = aws_vpc.tf_vpc.id

  # EKS 클러스터 → 노드 (Kubelet 관리)
  ingress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    description     = "Allow cluster to manage worker nodes"
    security_groups = [aws_security_group.tf_eks_cluster_sg.id]
  }

  # EKS 클러스터 → 노드 (Webhook, API 통신)
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    description     = "Allow cluster to communicate with worker nodes"
    security_groups = [aws_security_group.tf_eks_cluster_sg.id]
  }

  # DNS 요청 허용 (CoreDNS)
  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    description     = "Allow worker nodes to use DNS (UDP)"
    security_groups = [aws_security_group.tf_eks_cluster_sg.id]
  }

  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "tcp"
    description     = "Allow worker nodes to use DNS (TCP)"
    security_groups = [aws_security_group.tf_eks_cluster_sg.id]
  }

  # 노드 간 통신 (컨테이너 간 트래픽)
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    description = "Allow node-to-node communication"
    self        = true
  }

  # 노드 → AWS API, ECR, S3 (필수)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow nodes to communicate with AWS services"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 노드 → 외부 DNS 조회 (Amazon DNS or External DNS)
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    description = "Allow nodes to resolve external DNS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_eks_node_group_sg"
  }
}
