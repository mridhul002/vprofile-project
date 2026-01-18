#!/bin/bash
set -e

# Update system and install memcached
sudo apt update -y
sudo apt install memcached -y

# Start and enable memcached
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# Allow external connections (Ubuntu config file path)
sudo sed -i 's/^-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf

# Restart service to apply changes
sudo systemctl restart memcached

# (Optional) Manual start – usually NOT required on Ubuntu
# Keeping it only if your app explicitly needs it
sudo memcached -p 11211 -U 11111 -u memcached -d

echo "Memcached setup completed on Ubuntu"
