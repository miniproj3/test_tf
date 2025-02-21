# Terraform 폴더 내의 파일 구조

```
├── 🛠️ eks_cluster.tf           # EKS 클러스터 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ eks_nodegroup.tf         # EKS 노드 그룹 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ public_subnet.tf         # 퍼블릭 서브넷 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ private_subnet.tf        # 프라이빗 서브넷 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ rds.tf                   # RDS 데이터베이스 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ output.tf                # Terraform 출력 값 설정 파일
├── 🛠️ provider.tf              # Terraform 제공자 설정 파일 (AWS와의 연결)
├── 🛠️ eks_addon.tf             # EKS 애드온 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ route53.tf               # Route 53 설정을 정의하는 Terraform 구성 파일
├── 📝 userdata.tpl             # EC2 인스턴스 초기화 스크립트 템플릿
├── 🛠️ bastion.tf               # Bastion 호스트 설정을 정의하는 Terraform 구성 파일
├── 📊 terraform.tfstate        # Terraform 상태 파일 (현재 리소스 상태 정보)
├── 📊 terraform.tfstate.backup # Terraform 상태 백업 파일
├── 📄 apply.txt                # Terraform 적용 결과를 기록한 파일
├── 📄 plan.txt                 # Terraform 계획을 기록한 파일
├── 📚 README.md                # 프로젝트 설명 문서
```

<br>

🛠️: Terraform 구성 파일 (.tf) <br>
📝: 스크립트 템플릿 파일 (.tpl) <br>
📊: 상태 관련 파일 (.tfstate) <br>
📄: 텍스트 파일 (.txt) <br>
📚: 문서 파일 (.md) <br>

<br>
<br>
<br>

### 테라폼을 실행하는 VM에 helm 설치

```
[terraform@ip-192-168-10-138 terraform-aws]$ curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
Downloading https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
[sudo] password for terraform:
helm installed into /usr/local/bin/helm
[terraform@ip-192-168-10-138 terraform-aws]$ helm version
version.BuildInfo{Version:"v3.17.1", GitCommit:"980d8ac1939e39138101364400756af2bdee1da5", GitTreeState:"clean", GoVersion:"go1.23.5"}
```

<br>
<br>
<br>
