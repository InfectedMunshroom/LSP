#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
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

if ! ufw status | grep -q "$port"; then
  echo "Port $port is not currently allowed."
  exit 0
fi

echo "Disabling traffic on port $port..."
ufw delete allow $port

echo "Updated UFW status:"
ufw status

echo "Port $port has been disabled."