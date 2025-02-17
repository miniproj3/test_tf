# EKS Cluster
resource "aws_eks_cluster" "tf_eks_cluster" {
  name = "tf-eks-cluster"                            
  role_arn = aws_iam_role.tf_eks_cluster_iam_role.arn
  
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


