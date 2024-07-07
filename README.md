# AWS Dev Environment with Terraform
This project uses Terraform to set up a development environment on AWS. It includes the configuration of SSH access, user data scripts, and the provisioning of resources such as EC2 instances, VPC, and security groups.

## Files and Directories
- `.terraform/`: Directory containing Terraform state and configuration files.
- `.gitignore`: Git ignore file to exclude certain files and directories from version control.
- `.terraform.lock.hcl`: Lock file to ensure consistent Terraform operations.
- `datasources.tf`: Terraform file defining data sources.
- `linux-ssh-config.tpl`: Template file for SSH configuration on Linux instances.
- `main.tf`: Main Terraform configuration file defining resources.
- `outputs.tf`: Terraform file defining outputs from the Terraform state.
- `providers.tf`: Terraform file defining provider configurations.
- `terraform.tfstate`: State file tracking the state of the infrastructure.
- `terraform.tfstate.backup`: Backup of the state file.
- `terraform.tfvars`: File containing variable values.
- `userdata.tpl`: Template file for user data scripts to configure instances.
- `variables.tf`: Terraform file defining input variables.
- `windows-ssh-config.tpl`: Template file for SSH configuration on Windows instances.
- `README.md`: This file, containing project documentation.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS CLI configured with appropriate credentials and permissions.

## Setup Instructions
1. **Initialize Terraform**:
   ```sh
   terraform init
   ```

2. **Review and Modify Variables**:
   Ensure the `terraform.tfvars` file contains the correct values for your environment. Example:
   ```hcl
   host_os = "linux"
   home_ip = "123.456.789.0"
   ssh_public_path = "~/.ssh/id_rsa.pub"
   ssh_private_path = "~/.ssh/id_rsa"
   ```

3. **Plan the Deployment**:
   Review the execution plan for your infrastructure.
   ```sh
   terraform plan
   ```

4. **Apply the Configuration**:
   Deploy the infrastructure.
   ```sh
   terraform apply
   ```

## Infrastructure Overview
This Terraform configuration sets up a complete development environment on AWS:

### Provider Configuration (`providers.tf`)
Configures the AWS provider to interact with AWS services.

### Main Configuration (`main.tf`)
Defines the main infrastructure resources:
- VPC with DNS support and hostnames enabled
- Public subnet with automatic public IP assignment
- Internet Gateway
- Route Table with default route
- Security Group allowing inbound traffic from a specific IP
- SSH Key Pair
- EC2 Instance with user data scripts and SSH access setup

### Data Sources (`datasources.tf`)
Defines data sources to dynamically fetch data from existing infrastructure or cloud provider configurations.

### Variables (`variables.tf`)
Defines input variables:
- `host_os`: Host operating system (linux or windows)
- `home_ip`: Home IP address for security group ingress
- `ssh_public_path`: Path to SSH public key
- `ssh_private_path`: Path to SSH private key

### Outputs (`outputs.tf`)
Defines the output `dev_ip`, which provides the public IP address of the EC2 instance.

## EC2 Instance Configuration

The EC2 instance is automatically configured using the `userdata.tpl` script. This script is executed when the instance is first launched and sets up the environment with Docker and other essential tools.

### userdata.tpl
The `userdata.tpl` file contains a bash script that runs on instance launch. Here's a detailed breakdown of each command:

```bash
#!/bin/bash
```
This shebang line specifies that the script should be executed by the Bash shell.

```bash
sudo apt-get update -y
```
Updates the package lists for upgrades and new package installations. The `-y` flag automatically answers "yes" to prompts, allowing for non-interactive execution.

```bash
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
```
Installs necessary dependencies:
- `apt-transport-https`: Allows the package manager to transfer files and data over https
- `ca-certificates`: Allows SSL-based applications to check for the authenticity of SSL connections
- `curl`: A tool for transferring data using various protocols
- `gnupg-agent`: GNU privacy guard - a tool for secure communication and data storage
- `software-properties-common`: Provides an abstraction of the used apt repositories

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Downloads Docker's GPG key and adds it to the system's keyring. This ensures that the Docker packages we'll install are authenticated.
- `-fsSL`: Flags for curl (fail silently, show error, silent mode, follow redirects)

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
Adds the official Docker repository to the system:
- `deb`: Specifies that it's a Debian-style repository
- `[arch=amd64]`: Specifies the architecture
- `$(lsb_release -cs)`: Dynamically fetches the Ubuntu release codename (e.g., focal, bionic)
- `stable`: Indicates we're using the stable version of Docker

```bash
sudo apt-get update -y
```
Updates the package lists again, now including the newly added Docker repository.

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```
Installs Docker Community Edition:
- `docker-ce`: The Docker daemon, which manages containers
- `docker-ce-cli`: The Docker command-line interface
- `containerd.io`: An industry-standard container runtime

```bash
sudo usermod -aG docker ubuntu
```
Adds the `ubuntu` user to the `docker` group. This allows the user to run Docker commands without using `sudo`, which is more convenient and secure.
- `-a`: Append the user to the group, don't remove from other groups
- `-G`: Specifies that we're modifying group membership

This script ensures that your EC2 instance is fully prepared for Docker-based development immediately after launch. It installs all necessary dependencies, sets up the Docker repository, installs Docker CE, and configures user permissions for Docker usage.

## SSH Access
The project generates an SSH config file based on your host OS for easy connection to the EC2 instance.

For Linux/MacOS users:
```
ssh ubuntu@<dev_ip>
```

For Windows users, use PuTTY or Windows Subsystem for Linux (WSL) with the provided SSH key.

## Customization
You can modify `main.tf` to adjust the configuration according to your needs, such as changing the region, instance type, or adding additional resources.

## Cleaning Up
To destroy the infrastructure created by Terraform:
```sh
terraform destroy
```

## Troubleshooting
If you encounter issues:
1. Ensure all variables are correctly set in `terraform.tfvars`
2. Check AWS credentials and permissions
3. Verify that your IP address hasn't changed if you're having connection issues

For more help, please open an issue in the project repository.

## Future Enhancements
- Add support for multiple environments (dev, staging, prod)
- Implement auto-scaling for the EC2 instances
- Add more comprehensive monitoring and logging
- Integrate with CI/CD pipelines
