Platform DevOps Infrastructure

Welcome to the Platform DevOps Infrastructure repository! This repository contains Terraform configurations, scripts, and resources to manage infrastructure components such as EC2 instances, networking, EKS clusters, and supporting services like S3 buckets and DynamoDB tables.

📂 Repository Structure

├── .gitignore                  # Git ignore rules
├── README.md                   # Project documentation
├── .github/
│   └── workflows/
│       └── terraform.yml       # GitHub Actions workflow for Terraform
├── backend/
│   ├── bash-scripts/           # Bash scripts for automation
│   │   ├── installer.sh        # Script to install required tools
│   │   └── server-stats.sh     # Script to display server statistics
│   ├── ec2/                    # Terraform configurations for EC2
│   ├── eks_cluster/            # Terraform configurations for EKS cluster
│   ├── networking/             # Terraform configurations for networking
│   └── platform/               # Terraform configurations for platform resources

🚀 Prerequisites

Ensure the following tools are installed on your system:

AWS CLI

Terraform

Git

Kubectl

You can use the provided installer.sh script to install these tools.

⚙️ Usage

1️⃣ Clone the Repository

git clone https://github.com/your-repo/platform-devops.git
cd platform-devops

2️⃣ Initialize and Apply Terraform Configuration

terraform init
terraform plan -var-file=config/terraform.tfvars
terraform apply -var-file=config/terraform.tfvars -auto-approve

🔄 GitHub Actions Workflow

The repository includes a GitHub Actions workflow (.github/workflows/terraform.yml) that automatically validates and applies Terraform configurations when changes are pushed to the main branch.

🏗️ Modules Overview

🌐 Networking

Configurations for VPC, subnets, and security groups.

Files: main.tf, variables.tf

🖥️ EC2

Configurations for launching EC2 instances with security groups and load balancers.

Files: main.tf, variables.tf

☸️ EKS Cluster

Configurations for deploying an EKS cluster with managed node groups.

Files: main.tf, variables.tf

🗄️ Platform Resources

Configurations for S3 bucket and DynamoDB table for Terraform state management.

Files: s3_bucket.tf, dynamodb.tf

📝 Scripts

🔧 Installer Script

The installer.sh script installs the required tools (AWS CLI, Terraform, Git, Kubectl) on your system.

📊 Server Stats Script

The server-stats.sh script displays server performance statistics, including CPU, memory, and disk usage.

🔧 Configuration

📌 Terraform Variables

Each module includes a variables.tf file to define input variables.

Example variable files are provided in the config/ directory.

🗂️ Backend Configuration

Terraform state is stored in an S3 bucket with state locking enabled using a DynamoDB table.

Backend configurations are defined in backend.tf files.

📜 License

This project is licensed under the MIT License. See the LICENSE file for details.

🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

📬 Contact

For any questions or support, please contact the repository maintainer.