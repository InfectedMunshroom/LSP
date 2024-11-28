#!/bin/bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Exiting."
    exit 1
fi

is_openssh_installed() {
    if command -v ssh >/dev/null 2>&1 && command -v sshd >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

install_openssh() {
    apt update && apt install -y openssh-server
}

configure_openssh() {
    SSHD_CONFIG="/etc/ssh/sshd_config"
    if [ -f "$SSHD_CONFIG" ]; then
        cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"
    fi
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
    systemctl restart sshd
    systemctl enable sshd
}

start_ssh_server() {
    if systemctl is-active --quiet sshd; then
        echo "SSH server is already running."
    else
        echo "Starting SSH server..."
        systemctl start sshd
    fi
}

if is_openssh_installed; then
    echo "OpenSSH is already installed. Skipping installation."
else
    install_openssh
fi

# Ensure SSH server is running
start_ssh_server

configure_openssh
echo "OpenSSH setup and configuration complete."
