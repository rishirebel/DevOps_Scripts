#!/bin/bash

# Ask for sudo access upfront
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo ./server_setup.sh"
  exit 1
fi

set -e

NODE_VERSION='22.15.0'
export NVM_DIR="/usr/local/nvm"

# Ask user to set PostgreSQL password securely
echo "🔐 Enter a new password for PostgreSQL 'postgres' user:"
read -s -p "Password: " POSTGRES_PASSWORD
echo
read -s -p "Confirm Password: " POSTGRES_PASSWORD_CONFIRM
echo

if [ "$POSTGRES_PASSWORD" != "$POSTGRES_PASSWORD_CONFIRM" ]; then
  echo "❌ Passwords do not match. Exiting."
  exit 1
fi

echo "---- Updating system packages ----"
apt update && apt upgrade -y

echo "---- Installing curl, git, and build tools ----"
apt install -y curl git build-essential

echo "---- Installing NVM if not present ----"
if [ ! -d "$NVM_DIR" ]; then
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Add NVM to global system profile
if ! grep -q 'NVM_DIR' /etc/profile.d/nvm.sh 2>/dev/null; then
  cat <<EOF > /etc/profile.d/nvm.sh
export NVM_DIR="$NVM_DIR"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOF
fi

# Add NVM to root's bashrc
if ! grep -q 'NVM_DIR' /root/.bashrc 2>/dev/null; then
  cat <<EOF >> /root/.bashrc

# NVM Setup
export NVM_DIR="$NVM_DIR"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
EOF
fi

# Load NVM into current shell
source /etc/profile.d/nvm.sh

echo "---- Installing Node.js $NODE_VERSION via NVM ----"
if ! nvm ls "$NODE_VERSION" | grep -q "$NODE_VERSION"; then
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
fi

echo "---- Installing PM2 globally ----"
if ! command -v pm2 &>/dev/null; then
  npm install -g pm2
fi

echo "---- Installing NGINX ----"
if ! dpkg -s nginx &>/dev/null; then
  apt install -y nginx
  systemctl enable nginx
  systemctl start nginx
fi

echo "---- Installing PostgreSQL 14 ----"
if ! command -v psql &>/dev/null || ! psql --version | grep -q '14'; then
  if ! grep -q 'pgdg' /etc/apt/sources.list.d/pgdg.list 2>/dev/null; then
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/postgresql.gpg
    apt update
  fi
  apt install -y postgresql-14
fi

echo "---- Setting password for postgres user ----"
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='postgres'" | grep -q 1 && \
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${POSTGRES_PASSWORD}';"

# ✅ Enable PostgreSQL remote access
PG_CONF="/etc/postgresql/14/main/postgresql.conf"
HBA_CONF="/etc/postgresql/14/main/pg_hba.conf"

echo "---- Configuring PostgreSQL for remote access ----"
sed -i "s/^#listen_addresses =.*/listen_addresses = '*'/" "$PG_CONF"

if ! grep -q "^host.*all.*all.*0.0.0.0/0.*md5" "$HBA_CONF"; then
  echo "host    all             all             0.0.0.0/0               md5" >> "$HBA_CONF"
fi

if ! grep -q "^host.*all.*all.*::/0.*md5" "$HBA_CONF"; then
  echo "host    all             all             ::/0                    md5" >> "$HBA_CONF"
fi

systemctl restart postgresql
echo "✅ PostgreSQL is now accessible remotely on port 5432."

# Open firewall if UFW is installed
if command -v ufw &>/dev/null; then
  ufw allow 5432/tcp || true
fi

# Final summary
echo
echo "✅ Setup Completed Successfully!"
echo "🔑 Postgres user: postgres"
echo "🔐 Password set via prompt"
echo "🌐 PostgreSQL remote access enabled"
echo "📦 Node version: $(node -v)"
echo "📦 NPM version: $(npm -v)"
echo "🚀 PM2 version: $(pm2 -v)"
