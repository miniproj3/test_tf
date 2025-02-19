### 쿠버네티스 매니페스트

**Kubernetes 리소스 생성**
```
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f app-service.yaml
```
<br>

**AWS IAM Role 설정 (Secrets Manager 접근 권한 부여)**
EKS Pod가 Secrets Manager에서 정보를 가져올 수 있도록 IRSA를 설정해야 합니다.

IAM 정책 생성
secretsmanager-policy.json
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:rds-secret-*"
        }
    ]
}
```
IAM 역할 생성
```
aws iam create-role --role-name FlaskAppRole \
    --assume-role-policy-document file://eks-trust-policy.json

aws iam attach-role-policy --role-name FlaskAppRole \
    --policy-arn arn:aws:iam::aws:policy/secretsmanager-read-only
```
Kubernetes ServiceAccount 연결
service-account.yaml
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: flask-app-sa
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<AWS_ACCOUNT_ID>:role/FlaskAppRole
```
<br>
