#!/bin/bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Exiting."
    exit 1
fi

apt-get update
apt-get install clamav clamav-daemon -y
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam

cat > /etc/systemd/system/clamav-scan.timer << EOF
[Unit]
Description=Run ClamAV scan daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/clamav-scan.service << EOF
[Unit]
Description=ClamAV scan service

[Service]
Type=oneshot
ExecStart=/bin/bash -c '/usr/bin/clamscan -r / --exclude-dir="/sys" --exclude-dir="/proc" --exclude-dir="/dev" -l /var/log/clamav/clamscan_$(date +"%Y-%m-%d").log'
EOF

systemctl enable clamav-scan.timer
systemctl start clamav-scan.timer
systemctl status clamav-scan.timer
