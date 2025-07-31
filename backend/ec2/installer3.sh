#!/bin/bash

# Exit on error
set -e

# Function for logging
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    log "This script must be run as root or with sudo"
    exit 1
fi

log "Setting up SSH configuration..."
perl -pi -e 's/^#?Port 22$/Port 4545/' /etc/ssh/sshd_config
systemctl restart ssh

log "Updating system packages..."
apt-get update -y
apt-get install -y wget apt-transport-https ca-certificates curl

# PostgreSQL setup
log "Installing PostgreSQL..."
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
apt-get update -y
apt-get install -y postgresql-15

# NGINX setup
log "Restarting NGINX..."
service nginx restart

# Docker setup
log "Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
log "Docker status:"
systemctl status docker

# Kubernetes setup
log "Installing Kubernetes components..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
swapoff -a
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
systemctl enable kubelet

# Containerd setup
log "Configuring containerd..."
systemctl start containerd
containerd --version
containerd config default | tee /etc/containerd/config.toml
# Configure containerd to use systemd cgroup driver
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# Initialize Kubernetes
log "Initializing Kubernetes cluster..."
kubeadm init --ignore-preflight-errors=all --v=5

# Setup kubectl for the current user
log "Configuring kubectl..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install a pod network (using Calico as an example)
log "Installing pod network (Calico)..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Allow pods to be scheduled on the control-plane node (single-node setup)
log "Configuring single-node cluster..."
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

log "Installation complete! Kubernetes cluster is ready."

