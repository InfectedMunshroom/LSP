#!/bin/bash

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

if ! dpkg -s ufw &> /dev/null; then
  echo "UFW is not installed. Please install it first."
  exit 1
fi

read -p "Enter the port number to allow: " port

if [[ ! "$port" =~ ^[0-9]+$ ]]; then
  echo "Invalid port number. Please enter a valid number."
  exit 1
fi

if ufw status | grep -q "$port"; then
  echo "Port $port is already allowed."
  exit 0
fi

echo "Allowing traffic on port $port..."
ufw allow $port

echo "Updated UFW status:"
ufw status

echo "Port $port has been allowed."