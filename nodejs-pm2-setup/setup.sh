#!/bin/bash

# Node.js, NPM, and PM2 Setup Script
# This script installs Node.js via NVM, npm packages, and PM2 process manager

set -e

NODE_VERSION='22.15.0'
export NVM_DIR="/usr/local/nvm"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  print_error "Please run as root: sudo ./setup.sh"
  exit 1
fi

print_status "Starting Node.js, NPM, and PM2 setup..."

# Update system packages
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install essential tools
print_status "Installing curl, git, and build tools..."
apt install -y curl git build-essential

# Install NVM (Node Version Manager)
print_status "Checking NVM installation..."
if [ ! -d "$NVM_DIR" ]; then
  print_status "Installing NVM..."
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  print_warning "NVM already installed at $NVM_DIR"
fi

# Configure NVM in system profile
if ! grep -q 'NVM_DIR' /etc/profile.d/nvm.sh 2>/dev/null; then
  print_status "Configuring NVM in system profile..."
  cat <<EOF > /etc/profile.d/nvm.sh
export NVM_DIR="$NVM_DIR"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOF
fi

# Add NVM to root's bashrc
if ! grep -q 'NVM_DIR' /root/.bashrc 2>/dev/null; then
  print_status "Adding NVM to root's bashrc..."
  cat <<EOF >> /root/.bashrc

# NVM Setup
export NVM_DIR="$NVM_DIR"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
EOF
fi

# Load NVM into current shell
source /etc/profile.d/nvm.sh

# Install Node.js
print_status "Installing Node.js version $NODE_VERSION..."
if ! nvm ls "$NODE_VERSION" | grep -q "$NODE_VERSION"; then
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
  nvm use default
  print_status "Node.js $NODE_VERSION installed successfully"
else
  print_warning "Node.js $NODE_VERSION already installed"
  nvm use "$NODE_VERSION"
fi

# Verify Node.js and NPM installation
print_status "Verifying Node.js and NPM installation..."
NODE_INSTALLED=$(node -v 2>/dev/null || echo "not installed")
NPM_INSTALLED=$(npm -v 2>/dev/null || echo "not installed")

if [ "$NODE_INSTALLED" = "not installed" ]; then
  print_error "Node.js installation failed"
  exit 1
fi

if [ "$NPM_INSTALLED" = "not installed" ]; then
  print_error "NPM installation failed"
  exit 1
fi

# Update NPM to latest version
print_status "Updating NPM to latest version..."
npm install -g npm@latest

# Install PM2 globally
print_status "Installing PM2 process manager..."
if ! command -v pm2 &>/dev/null; then
  npm install -g pm2
  print_status "PM2 installed successfully"
else
  print_warning "PM2 already installed, updating to latest version..."
  npm update -g pm2
fi

# Install additional useful global packages
print_status "Installing additional useful npm packages..."
npm install -g nodemon
npm install -g npm-check-updates
npm install -g yarn

# Configure PM2 to start on system boot
print_status "Configuring PM2 startup script..."
pm2 startup systemd -u root --hp /root
systemctl enable pm2-root || true

# Create PM2 ecosystem configuration template
print_status "Creating PM2 ecosystem configuration template..."
cat <<EOF > /root/ecosystem.config.js
module.exports = {
  apps: [{
    name: 'app-name',
    script: './app.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true,
    watch: false,
    max_memory_restart: '1G',
    autorestart: true,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};
EOF

# Create useful PM2 commands script
print_status "Creating PM2 helper commands..."
cat <<'EOF' > /usr/local/bin/pm2-helpers
#!/bin/bash

case "$1" in
  list)
    pm2 list
    ;;
  monit)
    pm2 monit
    ;;
  logs)
    pm2 logs --lines 100
    ;;
  restart-all)
    pm2 restart all
    ;;
  reload-all)
    pm2 reload all
    ;;
  save)
    pm2 save
    ;;
  resurrect)
    pm2 resurrect
    ;;
  status)
    pm2 status
    ;;
  info)
    pm2 info "$2"
    ;;
  *)
    echo "Usage: pm2-helpers {list|monit|logs|restart-all|reload-all|save|resurrect|status|info <app-name>}"
    exit 1
    ;;
esac
EOF

chmod +x /usr/local/bin/pm2-helpers

# Create Node.js project initialization script
print_status "Creating Node.js project initialization helper..."
cat <<'EOF' > /usr/local/bin/node-init
#!/bin/bash

PROJECT_NAME=${1:-"my-node-app"}
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

npm init -y
npm install express dotenv cors helmet morgan compression

cat <<'APPEOF' > app.js
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the API' });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
APPEOF

cat <<'ENVEOF' > .env
NODE_ENV=development
PORT=3000
ENVEOF

cat <<'GITEOF' > .gitignore
node_modules/
.env
*.log
.DS_Store
dist/
build/
*.pid
*.seed
*.pid.lock
GITEOF

echo "✅ Node.js project '$PROJECT_NAME' initialized!"
echo "📁 cd $PROJECT_NAME"
echo "🚀 npm start or pm2 start app.js"
EOF

chmod +x /usr/local/bin/node-init

# Display installation summary
echo
echo "======================================"
print_status "Installation Complete!"
echo "======================================"
echo
echo "📦 Installed Versions:"
echo "  • Node.js: $(node -v)"
echo "  • NPM: $(npm -v)"
echo "  • PM2: $(pm2 -v)"
echo "  • Nodemon: $(nodemon -v 2>/dev/null || echo 'installed')"
echo "  • Yarn: $(yarn -v 2>/dev/null || echo 'installed')"
echo
echo "🛠️  Helper Commands:"
echo "  • pm2-helpers - PM2 management shortcuts"
echo "  • node-init <project-name> - Initialize new Node.js project"
echo
echo "📝 PM2 Ecosystem Config:"
echo "  • Template saved at: /root/ecosystem.config.js"
echo
echo "🚀 Quick Start:"
echo "  1. Create new project: node-init my-app"
echo "  2. Start with PM2: pm2 start app.js"
echo "  3. Monitor: pm2 monit"
echo "  4. View logs: pm2 logs"
echo
echo "======================================"