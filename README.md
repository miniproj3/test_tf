# test_tf
예시 )
│   ├── 📁 network/           # VPC, Subnet, NAT Gateway 등 <br>
│   ├── 📁 compute/           # EC2 인스턴스, Auto Scaling 등 <br>
│   ├── 📁 storage/           # S3 버킷, EBS 볼륨 등 <br>
│   ├── 📁 iam/               # IAM 사용자, 역할 및 정책 <br>
│   └── 📁 database/          # RDS, DynamoDB 등 데이터베이스 리소스 <br>

 ```[terraform@ip-192-168-10-138 terraform-aws]$ aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.31/amazon-linux-2/recommended/image_id --region ap-northeast-2 --query "Parameter.Value" --output text
ami-0fa05db9e3c145f63 ```

