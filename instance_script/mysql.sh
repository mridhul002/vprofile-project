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

# Clone YOUR vProfile repo (CHANGE THIS TO YOUR GIT URL)
git clone -b main https://github.com/mridhul002/vprofile-project.git

# Configure MariaDB root password
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS';"

# Secure MariaDB (similar to mysql_secure_installation)
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Create vProfile database and user
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE accounts;"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';"

# Restore database
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

