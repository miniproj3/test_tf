# Kubernetes Provider 설정
provider "kubernetes" {
  host                   = aws_eks_cluster.tf_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.tf_eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.tf_eks_cluster.name]
  }
}

# Helm Provider 설정
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.tf_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.tf_eks_cluster.certificate_authority[0].data)
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.tf_eks_cluster.name]
    }
  }
}

# OIDC 프로바이더 생성 (thumbprint 생략)
resource "aws_iam_openid_connect_provider" "tf_oidc_provider" {
  client_id_list = ["sts.amazonaws.com"]
  url            = aws_eks_cluster.tf_eks_cluster.identity[0].oidc[0].issuer
}



module "eks_blueprints_addons" {
  source                 = "aws-ia/eks-blueprints-addons/aws"
  version                = "~> 1.0"

  cluster_name           = aws_eks_cluster.tf_eks_cluster.name
  cluster_endpoint       = aws_eks_cluster.tf_eks_cluster.endpoint
  cluster_version        = "1.31"
  oidc_provider_arn      = aws_iam_openid_connect_provider.tf_oidc_provider.arn

  eks_addons             = {
    aws-ebs-csi-driver   = { most_recent = true }
    coredns              = { most_recent = true }
    vpc-cni              = { most_recent = true }
    kube-proxy           = { most_recent = true }
  }

  enable_aws_load_balancer_controller    = true
  # enable_cluster_proportional_autoscaler = true
  enable_karpenter                       = true
  enable_kube_prometheus_stack           = true
  enable_metrics_server                  = true
  enable_external_dns                    = true
  enable_cert_manager                    = true
  cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/Z0606134MJ4WUL8MELBR"] # hostezone/<호스팅 영역ID>

  depends_on = [ aws_eks_cluster.tf_eks_cluster ]

  tags                                   = {
    Environment                          = "dev"
  }
}

