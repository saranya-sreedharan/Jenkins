#!/bin/bash

# Colors for text formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display error message and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" 1>&2
    exit 1
}

# Function to display success message
success_msg() {
    echo -e "${GREEN}$1${NC}"
}

# Update package repositories
echo "Updating package repositories..."
sudo apt update || error_exit "Failed to update package repositories."

# Install Docker
echo "Installing Docker..."
sudo apt install docker.io -y || error_exit "Failed to install Docker."

# Create Docker volumes
echo "Creating Docker volumes..."
sudo docker volume create jenkins_data || error_exit "Failed to create Docker volume jenkins_data."
sudo docker volume create --driver local --opt type=none --opt device=/mnt/jenkins_data --opt o=bind jenkins_data || error_exit "Failed to create Docker volume jenkins_data."

# Change ownership and permissions of Jenkins data directory
echo "Changing ownership and permissions of Jenkins data directory..."
sudo chown -R 1000:1000 /home/ubuntu/jenkins_data || error_exit "Failed to change ownership of Jenkins data directory."
sudo chmod -R 777 /home/ubuntu/jenkins_data || error_exit "Failed to change permissions of Jenkins data directory."

# Run Jenkins container
echo "Running Jenkins container..."
sudo docker run -d -p 8080:8080 -p 50000:50000 -v /home/ubuntu/jenkins_data:/var/jenkins_home --name jenkins jenkins/jenkins:lts || error_exit "Failed to run Jenkins container."

# Check Jenkins container logs and extract initial password
echo "Checking Jenkins container logs..."
CONTAINER_ID=$(sudo docker ps -q --filter "name=jenkins")
sudo docker logs $CONTAINER_ID
echo "$CONTAINER_LOGS"
# Wait for Jenkins to start
echo "Waiting for Jenkins to start..."
sleep 30


# Display success message
success_msg "Jenkins setup completed successfully. You can now access Jenkins at http://localhost:8080"	