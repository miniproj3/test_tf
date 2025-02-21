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

# 테라폼을 실행하는 VM에 helm 설치

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

# kubectl을 k로 별칭 만들기
```
# 터미널에서 ~/.bashrc 파일을 열기
vi ~/.bashrc

# 파일의 맨 아래에 아래 내용을 추가
alias k=kubectl

# 변경 사항 적용
source ~/.bashrc
```

<br>
<br>

# 테라폼 실행 후 리소스 확인
```
[ec2-user@ip-10-0-1-147 ~]$ k get nodes
NAME                                            STATUS   ROLES    AGE    VERSION
ip-10-0-3-31.ap-northeast-2.compute.internal    Ready    <none>   156m   v1.31.5-eks-5d632ec
ip-10-0-4-232.ap-northeast-2.compute.internal   Ready    <none>   156m   v1.31.5-eks-5d632ec
```

```
[ec2-user@ip-10-0-1-147 ~]$ k get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   164m
```

```
[ec2-user@ip-10-0-1-147 ~]$ k get namespace
NAME                    STATUS   AGE
cert-manager            Active   81m
default                 Active   165m
external-dns            Active   81m
karpenter               Active   81m
kube-node-lease         Active   165m
kube-prometheus-stack   Active   81m
kube-public             Active   165m
kube-system             Active   165m
```

```
[ec2-user@ip-10-0-1-147 ~]$ k get pods -n kube-system
NAME                                           READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-58b554974-rwfrg   1/1     Running   0          96m
aws-load-balancer-controller-58b554974-twcx8   1/1     Running   0          96m
aws-node-6cxpn                                 2/2     Running   0          95m
aws-node-r4wfq                                 2/2     Running   0          95m
coredns-86f5954566-knl94                       1/1     Running   0          95m
coredns-86f5954566-qdmwp                       1/1     Running   0          95m
ebs-csi-controller-5b7d498c64-chwlx            6/6     Running   0          95m
ebs-csi-controller-5b7d498c64-f58qj            6/6     Running   0          95m
ebs-csi-node-6sk6z                             3/3     Running   0          95m
ebs-csi-node-sj42q                             3/3     Running   0          95m
kube-proxy-l8ncf                               1/1     Running   0          95m
kube-proxy-wcskn                               1/1     Running   0          95m
metrics-server-59659dbfc9-gswr4                1/1     Running   0          96m
```
<br>
<br>
