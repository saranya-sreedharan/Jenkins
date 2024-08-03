#!/bin/bash
# This script will install Jenkins on Ubuntu 20.04

# Colors for text formatting
RED='\033[0;31m'  # Red colored text
NC='\033[0m'      # Normal text
YELLOW='\033[33m'  # Yellow Color
GREEN='\033[32m'   # Green Color
BLUE='\033[34m'    # Blue Color

# Function to display error messages
display_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    display_error "This script must be run as root."
fi

# Update system
echo -e "${YELLOW}...Updating the system...${NC}"
if ! sudo apt update; then 
    display_error "System failed to update."
fi

# Install OpenJDK 11
echo -e "${YELLOW}...Installing java before installing jenkins...${NC}"
if ! sudo apt install -y openjdk-11-jdk; then
    display_error "Failed to install OpenJDK 11."
fi

echo -e "${YELLOW}...check the wget is installing...${NC}"

if ! command -v wget &> /dev/null; then
    echo -e "${YELLOW}...Installing wget...${NC}"
    sudo apt-get install -y wget || display_error "Failed to install wget."
fi


# Add Jenkins keyring
echo -e "${YELLOW}...Add Jenkins library...${NC}"
if ! sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key; then
    display_error "Failed to download Jenkins keyring."
fi


# Add Jenkins apt repository entry
echo -e "${YELLOW}...Add Jenkins apt repository...${NC}"
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update apt repository
echo -e "${YELLOW}...Update apt repository...${NC}"
if ! sudo apt-get update; then
    display_error "Failed to update apt repository."
fi

# Install Jenkins
echo -e "${YELLOW}...Installing Jenkins...${NC}"
if ! sudo apt-get install -y jenkins; then
    display_error "Failed to install Jenkins."
fi

# Display Jenkins initial admin password

echo -e "${YELLOW}...Note the password to login to Jenkins...${NC}"

jenkins_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
if [ -z "$jenkins_password" ]; then
    display_error "Failed to retrieve Jenkins initial admin password."
else
    echo -e "${GREEN}Jenkins installed successfully.${NC}"
    echo -e "${YELLOW}Jenkins initial admin password:${NC} $jenkins_password"
    echo -e "${BLUE}Jenkins is running on port 8080.${NC}"
fi
