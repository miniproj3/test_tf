# Terraform 폴더 내의 파일 구조

```
├── 🛠️ eks_cluster.tf           # EKS 클러스터 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ eks_nodegroup.tf         # EKS 노드 그룹 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ eks_addon.tf             # EKS 애드온 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ public_subnet.tf         # 퍼블릭 서브넷 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ private_subnet.tf        # 프라이빗 서브넷 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ rds.tf                   # RDS 데이터베이스 리소스를 정의하는 Terraform 구성 파일
├── 🛠️ output.tf                # Terraform 출력 값 설정 파일
├── 🛠️ provider.tf              # Terraform 제공자 설정 파일 (AWS와의 연결)
├── 🛠️ vpc.tf                   # vpc 리소스를 정의하는 Terraform 구성 파일
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
```
[ec2-user@ip-10-0-1-147 ~]$ k get all -A
NAMESPACE               NAME                                                            READY   STATUS             RESTARTS        AGE
cert-manager            pod/cert-manager-7ddb454967-65k8f                               1/1     Running            0               3h38m
cert-manager            pod/cert-manager-cainjector-766dd9ccf7-tjhsv                    1/1     Running            0               3h38m
cert-manager            pod/cert-manager-webhook-9c98cff95-6r5wg                        1/1     Running            0               3h38m
external-dns            pod/external-dns-7465775dd-cb2lx                                0/1     CrashLoopBackOff   47 (2m9s ago)   3h38m
karpenter               pod/karpenter-69c574fd78-tjrst                                  1/1     Running            0               3h38m
karpenter               pod/karpenter-69c574fd78-zxbgs                                  1/1     Running            0               3h38m
kube-prometheus-stack   pod/alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running            0               3h31m
kube-prometheus-stack   pod/kube-prometheus-stack-grafana-d477cd865-zsxhl               3/3     Running            0               3h31m
kube-prometheus-stack   pod/kube-prometheus-stack-kube-state-metrics-7cc6fcdf84-ddn45   1/1     Running            0               3h31m
kube-prometheus-stack   pod/kube-prometheus-stack-operator-66f4fb967-6qhl9              1/1     Running            0               3h31m
kube-prometheus-stack   pod/kube-prometheus-stack-prometheus-node-exporter-6lcpl        1/1     Running            0               3h31m
kube-prometheus-stack   pod/kube-prometheus-stack-prometheus-node-exporter-sblmg        1/1     Running            0               3h31m
kube-prometheus-stack   pod/prometheus-kube-prometheus-stack-prometheus-0               2/2     Running            0               3h31m
kube-system             pod/aws-load-balancer-controller-58b554974-rwfrg                1/1     Running            0               3h38m
kube-system             pod/aws-load-balancer-controller-58b554974-twcx8                1/1     Running            0               3h38m
kube-system             pod/aws-node-6cxpn                                              2/2     Running            0               3h38m
kube-system             pod/aws-node-r4wfq                                              2/2     Running            0               3h38m
kube-system             pod/coredns-86f5954566-knl94                                    1/1     Running            0               3h38m
kube-system             pod/coredns-86f5954566-qdmwp                                    1/1     Running            0               3h38m
kube-system             pod/ebs-csi-controller-5b7d498c64-chwlx                         6/6     Running            0               3h38m
kube-system             pod/ebs-csi-controller-5b7d498c64-f58qj                         6/6     Running            0               3h38m
kube-system             pod/ebs-csi-node-6sk6z                                          3/3     Running            0               3h38m
kube-system             pod/ebs-csi-node-sj42q                                          3/3     Running            0               3h38m
kube-system             pod/kube-proxy-l8ncf                                            1/1     Running            0               3h38m
kube-system             pod/kube-proxy-wcskn                                            1/1     Running            0               3h38m
kube-system             pod/metrics-server-59659dbfc9-gswr4                             1/1     Running            0               3h38m

NAMESPACE               NAME                                                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                        AGE
cert-manager            service/cert-manager                                     ClusterIP   172.20.128.167   <none>        9402/TCP                       3h38m
cert-manager            service/cert-manager-webhook                             ClusterIP   172.20.218.183   <none>        443/TCP                        3h38m
default                 service/kubernetes                                       ClusterIP   172.20.0.1       <none>        443/TCP                        5h2m
external-dns            service/external-dns                                     ClusterIP   172.20.229.92    <none>        7979/TCP                       3h38m
karpenter               service/karpenter                                        ClusterIP   172.20.59.8      <none>        8000/TCP                       3h38m
kube-prometheus-stack   service/alertmanager-operated                            ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP     3h31m
kube-prometheus-stack   service/kube-prometheus-stack-alertmanager               ClusterIP   172.20.126.9     <none>        9093/TCP,8080/TCP              3h31m
kube-prometheus-stack   service/kube-prometheus-stack-grafana                    ClusterIP   172.20.74.253    <none>        80/TCP                         3h31m
kube-prometheus-stack   service/kube-prometheus-stack-kube-state-metrics         ClusterIP   172.20.144.49    <none>        8080/TCP                       3h31m
kube-prometheus-stack   service/kube-prometheus-stack-operator                   ClusterIP   172.20.67.173    <none>        443/TCP                        3h31m
kube-prometheus-stack   service/kube-prometheus-stack-prometheus                 ClusterIP   172.20.143.255   <none>        9090/TCP,8080/TCP              3h31m
kube-prometheus-stack   service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   172.20.36.16     <none>        9100/TCP                       3h31m
kube-prometheus-stack   service/prometheus-operated                              ClusterIP   None             <none>        9090/TCP                       3h31m
kube-system             service/aws-load-balancer-webhook-service                ClusterIP   172.20.28.220    <none>        443/TCP                        3h38m
kube-system             service/eks-extension-metrics-api                        ClusterIP   172.20.187.45    <none>        443/TCP                        5h2m
kube-system             service/kube-dns                                         ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP,9153/TCP         5h
kube-system             service/kube-prometheus-stack-coredns                    ClusterIP   None             <none>        9153/TCP                       3h31m
kube-system             service/kube-prometheus-stack-kube-controller-manager    ClusterIP   None             <none>        10257/TCP                      3h31m
kube-system             service/kube-prometheus-stack-kube-etcd                  ClusterIP   None             <none>        2381/TCP                       3h31m
kube-system             service/kube-prometheus-stack-kube-proxy                 ClusterIP   None             <none>        10249/TCP                      3h31m
kube-system             service/kube-prometheus-stack-kube-scheduler             ClusterIP   None             <none>        10259/TCP                      3h31m
kube-system             service/kube-prometheus-stack-kubelet                    ClusterIP   None             <none>        10250/TCP,10255/TCP,4194/TCP   3h35m
kube-system             service/metrics-server                                   ClusterIP   172.20.23.102    <none>        443/TCP                        3h38m

NAMESPACE               NAME                                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR              AGE
kube-prometheus-stack   daemonset.apps/kube-prometheus-stack-prometheus-node-exporter   2         2         2       2            2           kubernetes.io/os=linux     3h31m
kube-system             daemonset.apps/aws-node                                         2         2         2       2            2           <none>                     5h
kube-system             daemonset.apps/ebs-csi-node                                     2         2         2       2            2           kubernetes.io/os=linux     3h38m
kube-system             daemonset.apps/ebs-csi-node-windows                             0         0         0       0            0           kubernetes.io/os=windows   3h38m
kube-system             daemonset.apps/kube-proxy                                       2         2         2       2            2           <none>                     5h

NAMESPACE               NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
cert-manager            deployment.apps/cert-manager                               1/1     1            1           3h38m
cert-manager            deployment.apps/cert-manager-cainjector                    1/1     1            1           3h38m
cert-manager            deployment.apps/cert-manager-webhook                       1/1     1            1           3h38m
external-dns            deployment.apps/external-dns                               0/1     1            0           3h38m
karpenter               deployment.apps/karpenter                                  2/2     2            2           3h38m
kube-prometheus-stack   deployment.apps/kube-prometheus-stack-grafana              1/1     1            1           3h31m
kube-prometheus-stack   deployment.apps/kube-prometheus-stack-kube-state-metrics   1/1     1            1           3h31m
kube-prometheus-stack   deployment.apps/kube-prometheus-stack-operator             1/1     1            1           3h31m
kube-system             deployment.apps/aws-load-balancer-controller               2/2     2            2           3h38m
kube-system             deployment.apps/coredns                                    2/2     2            2           5h
kube-system             deployment.apps/ebs-csi-controller                         2/2     2            2           3h38m
kube-system             deployment.apps/metrics-server                             1/1     1            1           3h38m

NAMESPACE               NAME                                                                  DESIRED   CURRENT   READY   AGE
cert-manager            replicaset.apps/cert-manager-7ddb454967                               1         1         1       3h38m
cert-manager            replicaset.apps/cert-manager-cainjector-766dd9ccf7                    1         1         1       3h38m
cert-manager            replicaset.apps/cert-manager-webhook-9c98cff95                        1         1         1       3h38m
external-dns            replicaset.apps/external-dns-7465775dd                                1         1         0       3h38m
karpenter               replicaset.apps/karpenter-69c574fd78                                  2         2         2       3h38m
kube-prometheus-stack   replicaset.apps/kube-prometheus-stack-grafana-d477cd865               1         1         1       3h31m
kube-prometheus-stack   replicaset.apps/kube-prometheus-stack-kube-state-metrics-7cc6fcdf84   1         1         1       3h31m
kube-prometheus-stack   replicaset.apps/kube-prometheus-stack-operator-66f4fb967              1         1         1       3h31m
kube-system             replicaset.apps/aws-load-balancer-controller-58b554974                2         2         2       3h38m
kube-system             replicaset.apps/coredns-86f5954566                                    2         2         2       3h38m
kube-system             replicaset.apps/coredns-9b5bc9468                                     0         0         0       5h
kube-system             replicaset.apps/ebs-csi-controller-5b7d498c64                         2         2         2       3h38m
kube-system             replicaset.apps/metrics-server-59659dbfc9                             1         1         1       3h38m

NAMESPACE               NAME                                                               READY   AGE
kube-prometheus-stack   statefulset.apps/alertmanager-kube-prometheus-stack-alertmanager   1/1     3h31m
kube-prometheus-stack   statefulset.apps/prometheus-kube-prometheus-stack-prometheus       1/1     3h31m
```
