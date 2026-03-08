# OpenCSP Core

A repository for building the base infrastructure (Proxmox VM + K3s) to operate the OpenCSP service.

`./bootstrap` is run once from your local PC. After that, internal infrastructure configuration is written in `./cluster` and managed via GitOps.

## Prerequisites
* Terraform or OpenTofu installed on your local PC
* Ansible installed on your local PC
* Proxmox server access credentials (API Token, SSH Key)
* A GitHub token granting FluxCD access to the ops repository


## Step 1: Create Control Plane (Proxmox VM) with Terraform

1. Navigate to the `bootstrap/terraform` directory.
2. Copy the sample file to create your configuration file.
    ```sh
    cp terraform.tfvars.sample terraform.tfvars
    ```
3. Open `terraform.tfvars` and fill in your Proxmox connection details and node specs.
4. Create the VMs.
    ```sh
    terraform init
    terraform plan  # optional
    terraform apply
    ```
    > Note: Once complete, `bootstrap/ansible/inventory.ini` will be generated automatically.

## Step 2: Configure Control Plane Internals (K3s + GitOps) with Ansible

1. Navigate to the `bootstrap/ansible` directory.
2. Download the required roles.
    ```sh
    ansible-galaxy install -r requirements.yml --force
    ```
3. Run the playbook to set up the K3s cluster and configure GitOps.
    ```sh
    ansible-playbook site.yml -e "netbird_setup_key=YOUR_ACTUAL_SETUP_KEY" -e "github_token=ghp_YOUR_TOKEN_HERE"
    ```
    - Once the playbook completes, FluxCD-related files will be created under `cluster/` (in `flux-system`). All subsequent internal infrastructure configuration should be written in `./cluster`.


## Node Management Strategy (Blue/Green Update)

When a node spec change or OS upgrade is needed, replace the node rather than modifying it in place.

1. Add a new node to the `k3s_nodes` list in `terraform.tfvars` (e.g., add `ops-worker-02`).
2. Run `terraform apply` and `ansible-playbook` — the new node joins the cluster.
3. Drain the old node (`ops-worker-01`).
    ```sh
    kubectl drain ops-worker-01 --ignore-daemonsets --delete-emptydir-data
    ```
4. Remove the old node (`ops-worker-01`) from `terraform.tfvars`.
5. Run `terraform apply` — the old VM is safely deleted.