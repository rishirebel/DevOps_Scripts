# Node.js + PostgreSQL Stack

Complete server setup for Node.js applications with PostgreSQL database. This stack provides the core backend infrastructure for modern web applications and APIs.

## 🛠️ Stack Components

- **Node.js**: v22.0.15 (via NVM, system-wide installation)
- **PostgreSQL**: 14.x with remote access enabled
- **PM2**: Process manager for Node.js applications
- **Essential Tools**: curl, git, build-essential

## 📋 Scripts Overview

### 1. server_setup.sh
**Purpose**: Complete server provisioning and stack installation

**What it installs:**
- Node.js v22.0.15 via NVM (system-wide configuration)
- PostgreSQL 14 with database and user setup
- PM2 process manager (globally installed)
- Essential development tools (curl, git, build-essential)

**Key Features:**
- **Secure Database Setup**: Interactive PostgreSQL password configuration
- **Remote Access**: PostgreSQL configured for remote connections
- **System-wide NVM**: Node.js available to all users
- **Service Management**: Auto-start configuration for PostgreSQL
- **Firewall Configuration**: UFW rules for PostgreSQL port

**Usage:**
```bash
sudo ./server_setup.sh
```

### 2. post_setup_check.sh
**Purpose**: Stack validation and system monitoring

**What it checks:**
- **Software Versions**: Node.js, NPM, PM2, PostgreSQL
- **Service Status**: PostgreSQL service running status
- **Process Monitoring**: Active Node.js processes
- **System Configuration**: Firewall and service settings

**Additional Setup:**
- **UFW Firewall**: Configures SSH and PostgreSQL port rules
- **PM2 Startup**: Sets up PM2 auto-start on boot
- **Service Validation**: Ensures all components are running

**Usage:**
```bash
./post_setup_check.sh
```

## 🚀 Usage Instructions

### Step 1: Server Setup
```bash
sudo ./server_setup.sh
```
**This will:**
- Install Node.js v22.0.15 via NVM
- Install and configure PostgreSQL 14
- Install PM2 process manager
- Configure system security (UFW firewall)
- Set up remote PostgreSQL access

### Step 2: Validation
```bash
./post_setup_check.sh
```
**This will:**
- Verify all installed software versions
- Check PostgreSQL service status
- Configure PM2 auto-startup
- Validate system configuration

## 📋 Prerequisites

- **Operating System**: Ubuntu 18.04+ or Debian 10+
- **System Access**: Root/sudo privileges required
- **Network**: Internet connection for package installation
- **Memory**: 1GB+ RAM (2GB+ recommended for production)
- **Storage**: 10GB+ available space

## 🔧 Configuration Details

### Node.js Configuration
- **Installation Method**: NVM (Node Version Manager)
- **Installation Path**: `/usr/local/nvm`
- **Global Access**: Available to all system users
- **Default Version**: v22.0.15
- **PM2 Installation**: Global NPM package

### PostgreSQL Configuration
- **Version**: 14.x (latest stable)
- **Database User**: postgres
- **Remote Access**: Enabled (0.0.0.0/0)
- **Port**: 5432
- **Authentication**: MD5 password authentication

### Security Configuration
- **UFW Firewall**: Configured for essential ports (SSH, PostgreSQL)
- **PostgreSQL Access**: Password-protected remote access
- **Port Configuration**: Only necessary ports opened

## 🎯 Perfect For

### Application Types
- **REST APIs**: Node.js backend with PostgreSQL
- **Web Applications**: Full-stack applications
- **Microservices**: Service-oriented architectures
- **Real-time Applications**: WebSocket-based apps
- **Data Processing**: Applications requiring robust database

### Development Scenarios
- **Local Development**: Development environment setup
- **Staging Servers**: Pre-production testing
- **Production Deployment**: Production-ready configuration
- **CI/CD Pipelines**: Automated deployment targets

## 🔄 Next Steps After Setup

### 1. Deploy Your Application
```bash
# Clone your Node.js application
git clone your-repo.git
cd your-app

# Install dependencies
npm install

# Start with PM2
pm2 start server.js --name "your-app"
pm2 save
```

### 2. Database Configuration
```bash
# Connect to PostgreSQL
psql -h localhost -U postgres

# Create application database
CREATE DATABASE your_app_db;

# Create application user
CREATE USER your_app_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE your_app_db TO your_app_user;
```

### 3. Domain Setup (Optional)
For web applications requiring domain access:
```bash
# Use the separate nginx-domain-ssl-setup module
cd ../nginx-domain-ssl-setup
./setup_domain.sh
```

## 🔐 Security Considerations

### Database Security
- **Strong Passwords**: Use complex passwords for PostgreSQL
- **Network Security**: Consider VPN for remote database access
- **Regular Updates**: Keep PostgreSQL updated
- **Backup Strategy**: Implement regular database backups

### Application Security
- **Environment Variables**: Store sensitive data in environment files
- **Process Management**: Use PM2 for process monitoring
- **Log Management**: Monitor application and system logs

## 🚨 Important Notes

- **Production Use**: Review and harden security settings for production
- **Backup Strategy**: Implement database backup procedures
- **Monitoring**: Set up system and application monitoring
- **Updates**: Regularly update Node.js, PostgreSQL, and system packages

## 📝 Script Execution Flow

```
server_setup.sh → post_setup_check.sh
      ↓                    ↓
  Base Stack           Validation
```

Each script is designed to be idempotent - safe to run multiple times.