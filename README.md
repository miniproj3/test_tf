### secret manager를 이용한 환경변수 넘기기 (개발 - 컨테이너 - k8s - rds)
- 목적: AWS Secrets Manager에서 비밀번호를 가져오고, ConfigMap을 활용하여 RDS에 연결
-----------------------------------

app.py에서 RDS 비밀번호를 AWS Secrets Manager에서 가져오도록 수정해야 합니다.
또한, MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER 같은 정보는 쿠버네티스 ConfigMap을 이용하도록 설정할 것입니다.

다음은 해야 할 작업 목록입니다:

1. app.py 수정 (Secrets Manager에서 RDS 비밀번호 가져오기)
AWS SDK (boto3)를 사용해 AWS Secrets Manager에서 MYSQL_PASSWORD를 가져오도록 수정
나머지 환경 변수(MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER)는 기존처럼 os.getenv()를 통해 ConfigMap에서 설정
2. Dockerfile 수정
boto3 설치 추가 (AWS SDK 사용을 위해 필요)
3. 쿠버네티스 매니페스트 작성
ConfigMap: MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER 값 설정
Deployment: 환경 변수에서 ConfigMap을 사용하고, MYSQL_PASSWORD는 AWS Secrets Manager에서 가져오도록 설정
Service: EKS에서 컨테이너를 외부에 노출하는 서비스 생성
IAM Role & Policy 설정: EKS의 Pod가 AWS Secrets Manager에서 비밀번호를 가져올 수 있도록 IRSA(IAM Role for Service Account) 설정

-----------------------------------

배포 절차
ECR에 컨테이너 이미지 푸시
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker build -t gunicorntest .
docker tag gunicorntest:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/gunicorntest:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/gunicorntest:latest ```

Kubernetes 리소스 생성
kubectl apply -f db-configmap.yaml
kubectl apply -f service-account.yaml
kubectl apply -f app-deployment.yaml
kubectl apply -f app-service.yaml
