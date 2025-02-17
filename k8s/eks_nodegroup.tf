# AWS eks_node_group Resource
resource "aws_launch_template" "tf_eks_node_lt" {
  name_prefix   = "tf-eks-node-lt"
  image_id      = "ami-0a20b1b99b215fb27" # Linux 2 ami
  instance_type = "t3.medium"
  network_interfaces {
    security_groups             = [aws_security_group.tf_eks_node_group_sg.id]
  }
}

resource "aws_eks_node_group" "tf_eks_managed_node_group" {
  cluster_name    = aws_eks_cluster.tf_eks_cluster.name
  node_group_name = "tf-eks-managed-node-group"
  node_role_arn   = aws_iam_role.tf_eks_managed_node_role.arn
  subnet_ids      = [aws_subnet.tf_pri_sub_1.id, aws_subnet.tf_pri_sub_2.id]

  launch_template {
    id      = aws_launch_template.tf_eks_node_lt.id
    version = "$Latest"
  }

  disk_size      = 20
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.tf_eks_managed_node_group_policy_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.tf_eks_managed_node_group_policy_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.tf_eks_managed_node_group_policy_AmazonEC2ContainerRegistryReadOnly,
  ]

tags = {
    Name = "tf_eks_managed_node_group"
  }
}

