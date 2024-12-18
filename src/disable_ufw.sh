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

read -p "Enter the port number to disable: " port

if [[ ! "$port" =~ ^[0-9]+$ ]]; then
  echo "Invalid port number. Please enter a valid number."
  exit 1
fi

# Check if a rule exists for the specified port, allowing for variations in output
if ! ufw status numbered | grep -q "ALLOW IN .* $port/tcp" && ! ufw status numbered | grep -q "ALLOW IN .* $port"; then
  echo "No rule found for port $port."
  exit 0
fi

echo "Disabling traffic on port $port..."
ufw delete allow $port

echo "Updated UFW status:"
ufw status

echo "Port $port has been disabled."