#!/bin/bash
set -e

DATABASE_PASS='admin123'

# ---------- SYSTEM UPDATE ----------
sudo apt update -y

# ---------- INSTALL REQUIRED PACKAGES ----------
sudo apt install -y git zip unzip mariadb-server memcached

# ================== MARIADB SETUP ==================

sudo systemctl start mariadb
sudo systemctl enable mariadb

cd /tmp/

# Clone your vProfile repo
git clone -b main https://github.com/mridhul002/vprofile-project.git

# Configure MariaDB root password (Ubuntu-safe)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DATABASE_PASS';"

# Secure MariaDB (basic hardening)
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# ================== CREATE DB & USER (CORRECT WAY) ==================

# Create database
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE IF NOT EXISTS accounts;"

# Remove old admin user if exists (avoids conflicts)
sudo mysql -u root -p"$DATABASE_PASS" -e "DROP USER IF EXISTS 'admin'@'localhost';"
sudo mysql -u root -p"$DATABASE_PASS" -e "DROP USER IF EXISTS 'admin'@'%';"

# Create admin user with correct authentication (IMPORTANT for Ubuntu)
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY 'admin123';"

# Grant privileges
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost';"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%';"

# Restore database from your repo
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"


