#!/bin/bash
# This script will revert the installation of Jenkins on Ubuntu 20.04

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

# Uninstall Jenkins
echo -e "${YELLOW}...Uninstalling Jenkins...${NC}"
if ! sudo apt-get purge -y jenkins; then
    display_error "Failed to uninstall Jenkins."
fi

# Remove Jenkins keyring
echo -e "${YELLOW}...Removing Jenkins keyring...${NC}"
sudo rm /usr/share/keyrings/jenkins-keyring.asc

# Remove Jenkins apt repository entry
echo -e "${YELLOW}...Removing Jenkins apt repository entry...${NC}"
sudo rm /etc/apt/sources.list.d/jenkins.list

# Update apt repository
echo -e "${YELLOW}...Update apt repository...${NC}"
if ! sudo apt-get update; then
    display_error "Failed to update apt repository."
fi

# Remove OpenJDK 11
echo -e "${YELLOW}...Removing OpenJDK 11...${NC}"
if ! sudo apt-get purge -y openjdk-11-jdk; then
    display_error "Failed to remove OpenJDK 11."
fi

# Remove wget if it was installed during the Jenkins installation
echo -e "${YELLOW}...Removing wget...${NC}"
sudo apt-get purge -y wget

echo -e "${GREEN}Jenkins reverted successfully.${NC}"
