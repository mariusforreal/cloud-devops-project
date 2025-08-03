# ☁️ CloudDevOpsProject

A full-stack DevOps implementation showcasing how to build, deploy, and monitor a containerized app using DevOps tools like Docker, Kubernetes, Terraform, Ansible, Jenkins, ArgoCD, Prometheus, and Grafana.

---

## 🧠 What This Project Covers

- Local Kubernetes Cluster using **kubeadm** on VMware
- AWS EC2 Jenkins deployment with **Terraform**
- EC2 provisioning with **Ansible** and **Dynamic Inventory**
- CI/CD pipelines with **Jenkins**, integrated with **GitHub**
- GitOps deployment using **ArgoCD**
- VPN connection via **Tailscale** between cloud and local
- Monitoring via **Prometheus** and **Grafana**

---

📊 Project Architecture Diagram

![final pro0 drawio](https://github.com/user-attachments/assets/f03ef006-29c6-4ed5-a0a4-22462d098e28)

---
📁 Project Tree Overview
```
CloudDevOpsProject
├── ansible
│   ├── ansible.cfg
│   ├── aws_ec2.yml
│   ├── group_vars
│   │   └── Jenkins_Slave.yml
│   ├── mykey.pem
│   ├── playbooks
│   │   ├── jenkins-full-setup.yml
│   │   └── slave.yml
│   ├── roles
│   │   ├── common
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   ├── jenkins_master
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   └── jenkins_slave
│   │       └── tasks
│   │           └── main.yml
│   └── vars
│       └── main.yml
├── argocd
│   └── argocd-app.yaml
├── docker
│   └── Dockerfile
├── Jenkinsfile
├── k8s
│   ├── deployment.yaml
│   ├── generate-cm.py
│   ├── grafana-dashboard.yaml
│   ├── grafana-deployment.yaml
│   ├── grafana-service.yaml
│   ├── namespace.yaml
│   ├── new
│   │   ├── cluster-role-binding.yaml
│   │   ├── cluster-role.yaml
│   │   ├── deployment.yaml
│   │   ├── service-account.yaml
│   │   └── service.yaml
│   ├── node-exporter.json
│   ├── node-exporter.yaml
│   ├── prometheus-config.yaml
│   ├── prometheus-deployment.yaml
│   ├── prometheus-rbac.yaml
│   ├── prometheus-service.yaml
│   ├── README.md
│   └── service.yaml
├── my_app
│   ├── app.py
│   ├── README.md
│   ├── requirements.txt
│   ├── static
│   │   ├── logos
│   │   │   ├── ivolve-logo.png
│   │   │   └── nti-logo.png
│   │   └── style.css
│   └── templates
│       └── index.html
├── README.md
├── terraform
│   ├── backend.tf
│   ├── CloudDevOpsProject-keypair.pem
│   ├── images
│   │   ├── ec2 in aws.png
│   │   ├── jenkins.png
│   │   ├── terraform.png
│   │   └── tst jenkins.png
│   ├── jenkins_password.txt
│   ├── main.tf
│   ├── modules
│   │   ├── network
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── server
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── README.md
│   └── variables.tf
└── vars
    ├── buildDockerImage.groovy
    ├── deleteLocalDockerImage.groovy
    ├── pushDockerImage.groovy
    ├── scanDockerImage.groovy
    └── updateK8sManifests.groovy

```
---

## 🛠️ Step-by-Step Implementation

### 🔹 1. Kubernetes Cluster (Local) via `kubeadm`

The project started by setting up a Kubernetes cluster **locally** on VMware using `kubeadm`.

- ✅ 1x Master node
- ✅ 2x Worker nodes
- Installing Docker and kubeadm
- Initializing the master node
- Joining worker nodes
- Creating namespace `ivolve`
## 🔧 Step 1:  Install Docker on all Machine

```bash
sudo apt update 
# Install a prerequisite package that allows apt to utilize HTTPS:
sudo apt-get install apt-transport-https ca-certificates curl gpg
sudo install -m 0755 -d /etc/apt/keyrings
# Add GPG key for the official Docker repo to the Ubuntu system:
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the Docker repo to APT sources:
 echo \ 
  "deb [arch=$(dpkg --print-architecture) signed-
by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Update the database with the Docker packages from the added repo:
sudo apt-get update
# Install Docker software:
sudo apt install -y containerd.io docker-ce docker-ce-cli 
# Docker should now be installed, the daemon started, and the process enabled to start on boot. To verify:
sudo systemctl status docker
# Make the docker enable to start automatic when reboot the machine:
sudo systemctl enable docker 
sudo systemctl daemon-reload 
sudo systemctl enable docker 
sudo systemctl enable --now containerd
# Add user to docker Groups:
sudo usermod -aG docker ${USER} 
```

## 🛠️ Step 2: Install Install CNI Plugin
```
wget 
https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz 
sudo mkdir -p /opt/cni/bin 
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.4.0.tgz
sudo systemctl restart containerd 
sudo systemctl enable containerd 
```
## Step 3: swap & selinux
```
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 
sudo swapoff -a 
## Install selinux (in all Machine):
sudo apt install selinux-utils 
# Disable selinux (in all Machine):
setenforce 0 
```
## Step 4: Enable IP forwarding temporarily:
```
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
# Enable IP forwarding permanently:
#  Apply the changes:
sudo sysctl -p 
# Validate Containerd
sudo crictl info 
# Validate Containerd
cat /proc/sys/net/ipv4/ip_forward
# Give a unique hostname for all machines:
sudo hostnamectl set-hostname master 
sudo hostnamectl set-hostname node1 
sudo hostnamectl set-hostname node2 
```
### 🚫 Restart All Machines.

## step 5: Configure Hostname
Set the hostname for all machines
```
 sudo vim /etc/hosts 
```
ADD
```
<ip-master>   <hostname-master> 
<ip-node1>    <hostname-node1> 
<ip-node2>    <hostname-node2>
```
Check swap config, ensure swap is 0
```
free -m 
```
## step 6: Install Kubernetes on All Machines
Update your existing packages:
```
sudo apt-get update
# Install packages needed to use the Kubernetes apt repository:
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
#  Download the public signing key for the Kubernetes package repositories.
sudo mkdir -p -m 755 /etc/apt/keyrings 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
#  Add Kubernetes Repository:
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg]
https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list 
# Update your existing packages:
sudo apt-get update -y 
# Install Kubeadm:
sudo apt-get install -y kubelet kubeadm kubectl 
sudo apt-mark hold kubelet kubeadm kubectl
# Enable the kubelet service:
sudo systemctl enable --now kubelet 
# Enable kernel modules
sudo modprobe overlay 
sudo modprobe br_netfilter 
# Update Iptables Settings
 sudo tee /etc/sysctl.d/kubernetes.conf<<EOF 
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward = 1 
EOF
# Configure persistent loading of modules
sudo tee /etc/modules-load.d/k8s.conf <<EOF 
overlay 
br_netfilter 
EOF
# Reload sysctl
sudo sysctl --system 
# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker 
sudo systemctl enable docker 
sudo systemctl enable kubelet
```
step 7: Initialize Kubernetes on the Master Node
```
# Run the following command as sudo on the master node:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 
# To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# To Create a new token as root
sudo kubeadm token create --print-join-command 
# Deploy a Pod Network through the master node:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kubeflannel.yml
```
### 🚫 In the output, you can see the `kubeadm join`command and a unique token that you will run on the
 worker node and all other worker nodes that you want to join onto this cluster. Next, copy-paste this
 command as you will use it later in the worker node.

## step 8: Joining Worker Nodes to the Kubernetes Cluster
 You will use your kubeadm join command that was shown in your terminal when we initialized the master
 node.
 The command would be similar of this:
```
sudo kubeadm join 172.31.6.233:6443 --token 9lspjd.t93etsdpwm9gyfib -discovery-token-ca-cert-hash 
sha256:37e35d7ea83599356de1fc5c80c282285cc3c749443a1dafd8e73f40
```

## step 9:  Reset Kubeadm
```
sudo kubeadm reset -f 
```
## 🔍 Step 8: Verify Nodes & Pods (on Master)

<img width="565" height="103" alt="image" src="https://github.com/user-attachments/assets/becac18f-0df1-44bd-b767-c6d5fd05e77a" />

<img width="1127" height="352" alt="image" src="https://github.com/user-attachments/assets/41aa6438-1ec3-4479-8f09-86af0ddda647" />

🖼️ *Cluster Name Space:*


<img width="698" height="240" alt="image" src="https://github.com/user-attachments/assets/9ba7050c-0ec0-428d-a595-6cccf98363b2" />

---

### 🔹 2. Infrastructure Provisioning (AWS) with Terraform

I wrote and executed Terraform code to provision the following on AWS:

- A VPC (`10.0.0.0/16`)
- Public subnet for **Jenkins Master** (10.0.1.0/24)
- Private subnet for **Jenkins Slave** (10.0.10.0/24)
- Internet Gateway + Route Tables
- Security Groups for Jenkins
- EC2 instances (Amazon linux):
  - Jenkins Master in public subnet
  - Jenkins Slave in private subnet
- Remote state storage using **S3** and DynamoDB
- CloudWatch for EC2 monitoring

📂 Modules Used:
- `network/`
- `server/`

🖼️ *Terraform Output & Screenshots:*  

<img width="927" height="202" alt="terraform" src="https://github.com/user-attachments/assets/134c5fda-d184-475c-9f12-d13220d3eb29" />

---

### 🔹 3. Configuration Management with Ansible

Once EC2 instances were up, I used **Ansible** to configure the Jenkins Master:

- Used **Dynamic Inventory** 
- Installed:
  - Docker
  - Python
  - Git
  - Java
  - Jenkins
- Configured Jenkins to:
  - Start on boot
  - Print Admin password in the playbook output for easy access
- Everything structured via **Ansible Roles**

🗂️  Structure:

```
ansible
├── ansible.cfg
├── aws_ec2.yml
├── mykey.pem
├── playbooks
│   ├── jenkins-full-setup.yml
│   └── slave.yml
├── roles
│   ├── common
│   │   └── tasks
│   │       └── main.yml
│   ├── jenkins_master
│   │   └── tasks
│   │       └── main.yml
│   └── jenkins_slave
│       └── tasks
│           └── main.yml
└── vars
    └── main.yml
```
🖼️ Ansible playbook

<img width="575" height="531" alt="ans2" src="https://github.com/user-attachments/assets/42a33480-ae55-474c-99b7-5690e0be0e9b" />

<img width="555" height="750" alt="ans 1" src="https://github.com/user-attachments/assets/fa4bb790-3267-453a-aa7a-b128e189628d" />

---

### 🔹 4. VPN Tunnel via Tailscale

Since the Jenkins server is in AWS and the Kubernetes cluster is local, they can't communicate directly.

To solve this:
- Installed **Tailscale** on both:
  - Jenkins EC2 instance (cloud)
  - Kubernetes master node (local)
- Connected both nodes via **VPN tunnel**
- Ensured Jenkins could connect to the local Kubernetes API securely

🖼️

<img width="1607" height="405" alt="image" src="https://github.com/user-attachments/assets/897836f3-afba-4703-930d-334aa89e455e" />

🧠 **Note**: Also transferred the Kubernetes `kubeconfig` to EC2 Jenkins Master to allow deployment.

🖼️ from EC2

<img width="582" height="110" alt="image" src="https://github.com/user-attachments/assets/fdaf4385-8c2a-4ff6-ad5e-9c3980c836f0" />

---


### 🔹 5. Jenkins CI Setup

On the Jenkins web dashboard:

- Added a **Jenkins Agent (Slave)** to run builds in private subnet.
- Created a **multibranch pipeline** project.
- Connected GitHub repo with Webhook triggers.

🧪 Jenkins Pipeline Stages:
1. Build Docker image
2. Scan image with **Trivy**
3. Push image to registry
4. Delete local image
5. Update build number in K8s manifest
6. Commit updated YAML to GitHub

📁 Uses Shared Library (`vars/`) to manage stages in modular form.

🖼️
<img width="1398" height="735" alt="node slave logs" src="https://github.com/user-attachments/assets/4ab97f36-0b88-4c3b-b500-c9811b565b77" />

<img width="1675" height="543" alt="nodes in j" src="https://github.com/user-attachments/assets/613ba98c-28fd-4fbd-9231-9827d0c53929" />

<img width="1920" height="597" alt="image" src="https://github.com/user-attachments/assets/683e634b-eac1-479d-ac83-7a4aa777fd8b" />

---
### 🔹 6. GitOps Deployment with ArgoCD

Deployed **ArgoCD** inside the Kubernetes cluster:

- Installed using official Helm/Manifests
- Accessed ArgoCD UI and connected it to the GitHub repo
- Created ArgoCD `Application` manifest to deploy the app from repo to namespace `ivolve`
- ArgoCD continuously watches the repo for changes and syncs to cluster

📂 `argocd/app.yaml` contains the config.
🖼️
<img width="1666" height="967" alt="image" src="https://github.com/user-attachments/assets/3f5da09c-b18a-4dc2-b087-bb63ffb5a6c5" />

---

### 🔹 7. Monitoring with Prometheus & Grafana

To monitor the cluster:

- Installed **Prometheus** for metrics collection
- Installed **Grafana** for visualization
- Exposed Grafana on NodePort and accessed dashboards
- Created dashboards for:
  - Node usage
  - Pod CPU/Memory
  - Jenkins Job metrics (via exporters)

🖼️ Grafana dashboard:
<img width="1920" height="968" alt="image" src="https://github.com/user-attachments/assets/0e62bed2-883b-450b-8a85-ef2910706cdf" />

---
Credit for this project goes to:
Mahmoud Yassen  🔗 [(www.linkedin.com/in/myassenn01)]






