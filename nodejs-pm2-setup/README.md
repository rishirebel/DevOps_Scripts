# Node.js + PM2 Setup

Streamlined installation and configuration for Node.js runtime environment with PM2 process manager. This lightweight setup focuses exclusively on Node.js ecosystem tools without additional stack components.

## 🛠️ Stack Components

- **Node.js**: v22.15.0 (via NVM, system-wide installation)
- **NPM**: Latest version with automatic updates
- **PM2**: Production process manager for Node.js
- **Additional Tools**: Nodemon, npm-check-updates, Yarn
- **Build Tools**: Essential compilation tools for native modules

## 📋 Script Overview

### setup.sh
**Purpose**: Complete Node.js runtime environment setup with PM2 process management

**What it installs:**
- Node.js v22.15.0 via NVM (Node Version Manager)
- NPM package manager (auto-updated to latest)
- PM2 process manager with ecosystem configuration
- Development tools (Nodemon for auto-restart)
- Package management utilities (Yarn, npm-check-updates)
- Essential build tools for compiling native modules

**Key Features:**
- **System-wide NVM**: Node.js accessible to all users
- **PM2 Auto-startup**: Process manager configured to start on boot
- **Ecosystem Template**: Ready-to-use PM2 configuration file
- **Helper Scripts**: Utilities for quick project initialization
- **Colored Output**: Clear installation progress indicators

**Usage:**
```bash
sudo ./setup.sh
```

## 🚀 Usage Instructions

### Step 1: Make Script Executable
```bash
chmod +x setup.sh
```

### Step 2: Run Setup
```bash
sudo ./setup.sh
```

**This will:**
- Install and configure NVM system-wide
- Install Node.js v22.15.0 and set as default
- Update NPM to latest version
- Install PM2 with startup configuration
- Install development utilities
- Create helper scripts for project management

## 📋 Prerequisites

- **Operating System**: Ubuntu 18.04+ or Debian 10+
- **System Access**: Root/sudo privileges required
- **Network**: Internet connection for package downloads
- **Memory**: 512MB+ RAM (1GB+ recommended)
- **Storage**: 2GB+ available space

## 🔧 Configuration Details

### Node.js Configuration
- **Installation Method**: NVM (Node Version Manager)
- **Installation Path**: `/usr/local/nvm`
- **System Profile**: `/etc/profile.d/nvm.sh`
- **Default Version**: v22.15.0
- **Global Access**: Available to all system users

### PM2 Configuration
- **Startup Script**: Systemd service for auto-start
- **Ecosystem Config**: `/root/ecosystem.config.js`
- **Process Modes**: Cluster and fork mode support
- **Log Management**: Automated log rotation
- **Memory Management**: Auto-restart on memory limits

### Installed Global Packages
- **PM2**: Process manager with clustering
- **Nodemon**: Auto-restart during development
- **npm-check-updates**: Dependency version management
- **Yarn**: Alternative package manager

## 🛠️ Helper Tools

### 1. PM2 Helpers (`pm2-helpers`)
Quick commands for PM2 management:
```bash
pm2-helpers list          # List all processes
pm2-helpers monit         # Real-time monitoring
pm2-helpers logs          # View recent logs
pm2-helpers restart-all   # Restart all processes
pm2-helpers reload-all    # Zero-downtime reload
pm2-helpers save          # Save current process list
pm2-helpers resurrect     # Restore saved processes
pm2-helpers status        # Process status overview
pm2-helpers info <app>    # Detailed app information
```

### 2. Node Project Initializer (`node-init`)
Quick project scaffolding:
```bash
node-init my-app          # Create new Express.js project
```

Creates a complete project structure with:
- Express.js server setup
- Essential middleware (helmet, cors, compression)
- Environment configuration (.env)
- Git ignore configuration
- Health check endpoint
- Error handling middleware

## 🎯 Perfect For

### Use Cases
- **API Development**: RESTful API servers
- **Microservices**: Lightweight service deployments
- **Real-time Applications**: WebSocket servers
- **Build Servers**: CI/CD pipeline runners
- **Development Environments**: Local development setups
- **Worker Processes**: Background job processors

### Project Types
- **Express.js Applications**: Web servers and APIs
- **Next.js Applications**: React framework projects
- **NestJS Applications**: Enterprise Node.js apps
- **Socket.io Servers**: Real-time communication
- **CLI Tools**: Command-line applications
- **Static Site Generators**: Build processes

## 🔄 Post-Installation Steps

### 1. Verify Installation
```bash
node -v                   # Check Node.js version
npm -v                    # Check NPM version
pm2 -v                    # Check PM2 version
```

### 2. Create Your First Project
```bash
# Using the helper script
node-init my-first-app
cd my-first-app

# Start with PM2
pm2 start app.js --name my-app
pm2 save
```

### 3. Configure PM2 Ecosystem
Edit `/root/ecosystem.config.js` for your application:
```javascript
module.exports = {
  apps: [{
    name: 'your-app',
    script: './server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
};
```

Then start with:
```bash
pm2 start ecosystem.config.js
```

## 📊 PM2 Management

### Basic Commands
```bash
pm2 start app.js          # Start application
pm2 stop app              # Stop application
pm2 restart app           # Restart application
pm2 reload app            # Zero-downtime reload
pm2 delete app            # Remove from PM2
```

### Monitoring
```bash
pm2 monit                 # Real-time dashboard
pm2 status                # Process list
pm2 logs                  # Application logs
pm2 logs --lines 100      # Last 100 log lines
```

### Process Management
```bash
pm2 scale app +3          # Add 3 instances
pm2 scale app 2           # Scale to 2 instances
pm2 save                  # Save process list
pm2 resurrect             # Restore processes
pm2 startup               # Generate startup script
```

## 🔐 Security Considerations

### Process Security
- **User Isolation**: Run processes as non-root users
- **Environment Variables**: Use .env files for secrets
- **Memory Limits**: Configure max memory restart
- **Rate Limiting**: Implement request throttling

### System Security
- **Regular Updates**: Keep Node.js and packages updated
- **Dependency Scanning**: Use npm audit regularly
- **Process Monitoring**: Set up alerts for crashes
- **Log Management**: Implement log rotation

## 🚨 Troubleshooting

### Common Issues

**NVM Command Not Found**
```bash
source /etc/profile.d/nvm.sh
```

**PM2 Not Starting on Boot**
```bash
pm2 startup
pm2 save
```

**Permission Issues**
```bash
sudo chown -R $USER:$USER ~/.pm2
```

**Port Already in Use**
```bash
pm2 stop all
# or
lsof -i :3000  # Find process using port
```

## 📝 Maintenance

### Regular Tasks
- **Update Node.js**: `nvm install node --reinstall-packages-from=current`
- **Update NPM**: `npm install -g npm@latest`
- **Update PM2**: `npm install -g pm2@latest`
- **Check Updates**: `npm-check-updates -g`
- **Security Audit**: `npm audit`

### Monitoring Health
- **Process Status**: `pm2 status`
- **Memory Usage**: `pm2 monit`
- **Log Review**: `pm2 logs --lines 100`
- **Error Tracking**: Check error logs regularly

## 📚 Additional Resources

### Documentation
- [Node.js Docs](https://nodejs.org/docs/)
- [PM2 Documentation](https://pm2.keymetrics.io/)
- [NPM Documentation](https://docs.npmjs.com/)
- [NVM GitHub](https://github.com/nvm-sh/nvm)

### Best Practices
- Use ecosystem files for PM2 configuration
- Implement proper error handling
- Set up environment-specific configurations
- Monitor application performance
- Implement graceful shutdown handlers

## 🔄 Integration with Other Stacks

This setup can be combined with:
- **nginx-domain-ssl-setup**: For reverse proxy and SSL
- **nodejs-postgresql-stack**: For database integration
- **Docker**: For containerized deployments
- **Redis**: For caching and sessions

## 📋 Script Execution Flow

```
setup.sh
    ├── System Updates
    ├── NVM Installation
    ├── Node.js Setup
    ├── NPM Updates
    ├── PM2 Installation
    ├── Helper Scripts
    └── Configuration
```

The script is idempotent - safe to run multiple times without side effects.