# Automated OS Hardening & Cloud Secrets Management Pipeline

A security-focused Infrastructure as Code (IaC) and Configuration Management pipeline built inside Linux (WSL Ubuntu). This project demonstrates how to securely manage sensitive credentials locally using **Ansible Vault** and automate user access control and platform hardening on a live **AWS EC2** instance over encrypted SSH connections.

## 🛠️ Security & Communication Architecture

Instead of exposing passwords in plain text within code repositories, this pipeline encrypts data at rest locally and securely provisions the target system over the network:
<img src="./AWS Secure Configuration Management.gif" width="800">


1. **Infrastructure Provisioning**: `terraform apply` deploys a secure network perimeter (Security Group) and boots an Amazon Linux 2023 EC2 node tagged with `Role = webserver`.
2. **Local Data Encryption**: Sensitive database credentials are encrypted at rest locally inside `secrets.yml` using Ansible Vault (AES256). 
3. **Identity & Access Management (IAM)**: The playbook connects over a secure **SSH connection** (via `kamo.pem`) and escalates privileges to `sudo` root. It automatically provisions a new restricted operating system group (`dbadmins`) and a specific system user account (`jconsultant`).
4. **Secure Credential Injection**: Ansible hands off the decrypted configuration variables over the secure network pipe, writing them directly to `/etc/db_config.conf`, and forces a strict `0600` read-only permission mask so unauthorized system accounts are blocked.

---

## 📸 Security Verification Proofs

### 1. Local Encrypted Vault (Secrets Management)
Proof that sensitive passwords are encrypted locally and are completely safe from being leaked to public source control.

<img src="./Screenshot (1366).png" width="800">

### 2. Playbook Execution Recap
The successful terminal compilation showing the user creation, group mapping, and secure file injection tasks completed with zero errors.

*Drop your terminal playbook recap screenshot here*
<img src="./Screenshot (1367).png" width="800">

### 3. Server-Side Verification (Hardened Target State)
A live view from inside the AWS instance showing the decrypted credentials sitting inside the secure configuration file alongside its restricted `-rw-------` read/write permission mask.

*Drop your secure server terminal screenshot here*
<img src="./Screenshot (1368).png" width="800">

---

## 🚀 How to Run This Project Local

### Prerequisites
* Windows Subsystem for Linux (WSL Ubuntu)
* Terraform & Ansible installed locally
* Active AWS Credentials exported via `aws configure`

### Execution Sequence
1. Clone this repository and move your private key pair to `~/.ssh/kamo.pem` (Lock permissions down using `chmod 400`).
2. Re-create your local encrypted vault file:
   ```bash
   ansible-vault create secrets.yml
   ```
3. Initialize the infrastructure state and deploy the cloud nodes:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
<img src="./Screenshot (1369).png" width="800">
4. Run the security configuration layer (Enter your vault password when prompted):
   ```bash
   ansible-playbook -i aws_ec2.yml security_deploy.yml --private-key=~/.ssh/kamo.pem --ask-vault-pass
   ```
5. Tear down all active cloud infrastructure instantly when finished to prevent billing charges:
   ```bash
   terraform destroy -auto-approve
