# EKS Cluster
resource "aws_eks_cluster" "tf_eks_cluster" {
  name = "tf-eks-cluster"                            
  role_arn = aws_iam_role.eks_cluster_role.arn
  
  vpc_config {                                    
    subnet_ids = [aws_subnet.tf_pri_sub_1.id, aws_subnet.tf_pri_sub_2.id]
    endpoint_public_access  = false
    endpoint_private_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.tf_eks_cluster_policy_AmazonEKSClusterPolicy]
  security_group_ids = [aws_security_group.tf_eks_cluster_sg.id]

  tags = {
    Name = tf_eks_cluster
  }
}


# EKS 클러스터 IAM 역할
resource "aws_iam_role" "tf_eks_cluster_iam_role" {
  name = "tf-eks-cluster-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# 클러스터 IAM 정책 연결 - EKS 기본 정책
resource "aws_iam_role_policy_attachment" "tf_eks_cluster_policy_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tf_eks_cluster_iam_role.name
}



