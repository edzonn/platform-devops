#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Checking for existing installations..."

# Function to check if a command exists
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Check if all tools are installed
if is_installed aws && is_installed terraform && is_installed git; then
    echo "All tools (AWS CLI, Terraform, Git) are already installed."
    echo "AWS CLI version: $(aws --version)"
    echo "Terraform version: $(terraform -version | head -n 1)"
    echo "Git version: $(git --version)"
    exit 0
fi

# Update package list
sudo apt update

# Install prerequisite packages
sudo apt install -y curl unzip software-properties-common gnupg

# Install AWS CLI if not installed
if is_installed aws; then
    echo "AWS CLI is already installed: $(aws --version)"
else
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
    echo "AWS CLI installed: $(aws --version)"
fi

# Install Terraform if not installed
if is_installed terraform; then
    echo "Terraform is already installed: $(terraform -version | head -n 1)"
else
    echo "Installing Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y terraform
    echo "Terraform installed: $(terraform -version | head -n 1)"
fi

# Install Git if not installed
if is_installed git; then
    echo "Git is already installed: $(git --version)"
else
    echo "Installing Git..."
    sudo apt install -y git
    echo "Git installed: $(git --version)"
fi

echo "Installation process complete!"

