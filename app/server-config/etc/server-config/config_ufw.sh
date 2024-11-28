#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the user is root
if [ $(id -u) -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Update package index
echo "Updating package index..."
apt update

# Install UFW if not already installed
if ! dpkg -s ufw &> /dev/null; then
  echo "Installing UFW..."
  apt install -y ufw
else
  echo "UFW is already installed."
fi

# Allow SSH (port 22)
echo "Allowing SSH through the firewall..."
ufw allow ssh

# Allow HTTP and HTTPS (optional, for web servers)
echo "Allowing HTTP and HTTPS traffic..."
ufw allow http
ufw allow https

# Set default policies
echo "Setting default policies..."
ufw default deny incoming
ufw default allow outgoing

# Enable UFW service
echo "Enabling UFW service..."
ufw --force enable

echo "Firewall setup complete."
