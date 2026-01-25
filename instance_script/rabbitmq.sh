#!/bin/bash
set -e

# ---------- SYSTEM UPDATE ----------
sudo apt update -y

# ---------- INSTALL DEPENDENCIES ----------
sudo apt install -y curl socat logrotate

# ---------- ADD ERLANG REPOSITORY ----------
curl -fsSL https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb -o /tmp/erlang-solutions.deb
sudo dpkg -i /tmp/erlang-solutions.deb
sudo apt update -y

# ---------- ADD RABBITMQ REPOSITORY ----------
curl -fsSL https://packages.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo tee /etc/apt/trusted.gpg.d/rabbitmq.asc

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

sudo systemctl restart rabbitmq-server

# ---------- CREATE USER & SET PERMISSIONS ----------
# (Idempotent - safe to run multiple times)
sudo rabbitmqctl delete_user test 2>/dev/null || true

sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

echo "==== RabbitMQ setup completed on Ubuntu ===="
