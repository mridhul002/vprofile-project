#!/bin/bash
set -e

# ---------- SYSTEM UPDATE ----------
sudo apt update -y

# ---------- INSTALL DEPENDENCIES ----------
sudo apt install -y curl socat logrotate

# ---------- ADD RABBITMQ & ERLANG REPOSITORIES (Ubuntu) ----------

# Add Erlang repository
curl -fsSL https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb -o /tmp/erlang-solutions.deb
sudo dpkg -i /tmp/erlang-solutions.deb
sudo apt update -y

# Add RabbitMQ signing key
curl -fsSL https://packages.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo tee /etc/apt/trusted.gpg.d/rabbitmq.asc

# Add RabbitMQ repository
echo "deb https://packages.rabbitmq.com/debian $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

sudo apt update -y

# ---------- INSTALL ERLANG & RABBITMQ ----------
sudo apt install -y erlang rabbitmq-server

# ---------- START & ENABLE RABBITMQ ----------
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# ---------- CONFIGURE RABBITMQ (ALLOW REMOTE USERS) ----------
sudo mkdir -p /etc/rabbitmq
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Restart after config change
sudo systemctl restart rabbitmq-server

# ---------- CREATE USER & SET PERMISSIONS ----------
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

echo "==== RabbitMQ setup completed on Ubuntu ===="
