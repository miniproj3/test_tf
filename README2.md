╷
│ Error: creating EKS Node Group (tf-eks-cluster:tf-eks-managed-node-group): operation error EKS: CreateNodegroup, https response error StatusCode: 400, RequestID: 9c9275bd-8f22-4ecc-be7e-2abd15448204, InvalidParameterException: Disk size must be specified within the launch template.
│
│   with aws_eks_node_group.tf_eks_managed_node_group,
│   on ✏️eks_nodegroup.tf line 11, in resource "aws_eks_node_group" "tf_eks_managed_node_group":
│   11: resource "aws_eks_node_group" "tf_eks_managed_node_group" {
│
╵
