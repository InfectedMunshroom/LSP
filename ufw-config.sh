#!/bin/bash

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install UFW if not already installed
if ! dpkg -s ufw &> /dev/null; then
  echo "Installing UFW..."
  apt install -y ufw
fi

# Enable UFW service
echo "Enabling UFW service..."
systemctl enable ufw
systemctl start ufw

# Allow SSH (port 22)
echo "Allowing SSH through the firewall..."
ufw allow ssh

# Allow HTTP and HTTPS (optional, for web servers)
echo "Allowing HTTP and HTTPS traffic..."
ufw allow http
ufw allow https

# Enable the firewall with default rules
echo "Setting default policies and enabling UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw enable

echo "Firewall setup complete."