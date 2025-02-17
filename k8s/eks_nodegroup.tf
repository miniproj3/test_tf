# AWS eks_node_group Resource
resource "aws_eks_node_group" "tf_eks_managed_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "tf-eks-managed-node-group"
  node_role_arn   = aws_iam_role.tf_eks_managed_node_role.arn
  subnet_ids      = [aws_subnet.tf_pri_sub_1.id, aws_subnet.tf_pri_sub_2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"  # Amazon Linux 2 AMI
  disk_size      = 20
  capacity_type  = "ON_DEMAND"

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

tags = {
    Name = "tf_eks_managed_node_group"
  }
}

