# OpenCSP-Ops

OpenCSP 서비스를 운영하기 위한 베이스 인프라(Proxmox VM + K3s)를 구축하는 저장소입니다.

## 전제 조건 (Prerequisites)
* 로컬 PC에 Terraform 또는 OpenTofu 설치
* 로컬 PC에 Ansible 설치
* Proxmox 서버 접근 권한 (API Token, SSH Key)

## 1단계: Control plane (Proxmox VM) 생성 (Terraform)

1. `bootstrap/terraform` 폴더로 이동합니다.
2. 예제 파일을 복사하여 설정 파일을 생성합니다.
    ```sh
    cp terraform.tfvars.sample terraform.tfvars
    ```
3. terraform.tfvars를 열어 Proxmox 접속 정보와 노드 스펙을 입력합니다.
4. VM을 생성합니다.
    ```sh
    terraform init 
    terraform plan (optional)
    terraform apply
    ```
    > Note: 완료되면 bootstrap/ansible/inventory.ini 파일이 자동으로 생성됩니다.

## 2단계: Controle plane (K3s + GitOps) 내부 구성 (Ansible)
1. bootstrap/ansible 폴더로 이동합니다.
2. 필요한 역할을 다운로드합니다.
    ```sh
    ansible-galaxy install -r requirements.yml --force
    ```
3. 플레이북을 실행하여 K3s 클러스터를 구축하고 GitOps를 설정합니다.
    ```sh
     ansible-playbook site.yml -e "netbird_setup_key=YOUR_ACTUAL_SETUP_KEY" -e "github_token=ghp_YOUR_TOKEN_HERE"
    ```


# Blue/ Green Update

노드 스펙 변경이나 OS 업그레이드가 필요할 경우, 기존 노드를 수정하지 않고 교체합니다.

1. terraform.tfvars의 k3s_nodes 목록에 새로운 노드를 추가합니다. (예: ops-worker-02 추가)
2. terraform apply & ansible-playbook 실행 -> 새 노드가 클러스터에 합류(Join)합니다.
3. 기존 노드(ops-worker-01)를 Drain(비우기) 합니다.
    ```sh
    kubectl drain ops-worker-01 --ignore-daemonsets --delete-emptydir-data
    ```
4. terraform.tfvars에서 기존 노드(ops-worker-01)를 삭제합니다.
5. terraform apply 실행 -> 기존 VM이 안전하게 삭제됩니다.