# Setting Up a Virtual Machine in Azure and Running a Docker Application

This guide provides step-by-step instructions on how to set up a Virtual Machine (VM) in Azure and run an application inside the VM using Docker.

## Prerequisites

- Basic knowledge of Docker and Azure.
- Azure CLI installed on your local machine. If you don’t have it, you can install it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

## Steps to Set Up the VM in Azure

### 1. Log in to Azure

Open your terminal and log in to your Azure account using the following command:

```bash
az login
```

2. Create a Resource Group
Create a new resource group to organize your resources. Replace myResourceGroup and eastus with your preferred names and location.

```bash
az group create --name abhiii71 --location eastus
```

3. Create a Virtual Machine
Create a VM instance. You can choose the VM size, OS type, and other configurations as per your requirement.
```bash
az vm create \
  --resource-group abhiii71 \
  --name chess-deploy \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys
```

4. Open Ports for Docker
Open the necessary ports to allow traffic. For example, to allow HTTP traffic on port 8080:
```bash
az vm open-port --resource-group abhiii71 --name chess-deploy --port 8080
```

5. Connect to Your VM
Connect to your VM using SSH. Replace MY_VM_PUBLIC_IP with the public IP address of your VM, which can be found in the Azure portal or by using the following command:
```bash
ssh azureuser@MY_VM_PUBLIC_IP
```

6. Install Docker
Once you are connected to your VM, install Docker with the following commands:
```bash
# Update the package database
sudo apt-get update

# Install required packages
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database again
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce
```

7. Verify Docker Installation
Check that Docker is installed correctly:
```bash
sudo docker --version
```

### OR
Create Inventory File: Create an inventory file (inventory.ini) to define the Azure VM:

Run the Playbook: Use the following command to run the Ansible playbook:
```bash
ansible-playbook -i inventory.ini install_docker.yml
```


8. Build Your Docker Application
To build your Docker application using a cloned repository, follow these steps:

Clone the Repository: First, clone the repository from GitHub

```bash
git clone https://github.com/abhiii71/chess-game.git
```

Navigate to the Project Directory: Once the repository is cloned, navigate to the project directory.

```bash
cd chess-game
```
Build your Docker image. Replace your_image_name with your desired image name.

```bash
sudo docker build -t your_image_name .
```
#### or
Directly pull this image from DockerHub:
```bash
 docker pull helloabhii/chess
```

9. Run Your Docker Container
Run your Docker container, mapping the internal port (8080) to the external port (8080):
```bash
sudo docker run -d -p 8080:8080 helloabhii/chess
```

10. Access Your Application
You can access your application via a web browser or using curl:
```bash
curl http://MY_VM_PUBLIC_IP:8080
```

Cleanup Resources
To avoid unnecessary charges, you can delete the resource group, which will remove the VM and all associated resources:
```bash
az group delete --name abhiii71 --yes --no-wait
```

### Conclusion
You have successfully set up a VM in Azure and run your application inside the VM using Docker. For more complex deployments or production use, consider exploring Azure Kubernetes Service (AKS) or other container orchestration tools.


