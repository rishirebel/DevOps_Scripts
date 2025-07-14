# DevOps Scripts Collection

A comprehensive collection of DevOps automation scripts organized by technology stack. Each folder contains complete setup, configuration, and monitoring scripts for specific technology combinations, making it easy to deploy and manage different environments.

## 📁 Repository Structure

```
DevOps_Scripts/
├── nodejs-postgresql-stack/        # Node.js + PostgreSQL backend stack
│   ├── server_setup.sh            # Base stack installation
│   ├── post_setup_check.sh        # Stack-specific monitoring
│   └── README.md                  # Stack documentation
├── nginx-domain-ssl-setup/         # NGINX domain & SSL configuration
│   ├── setup_domain.sh            # Domain & SSL setup
│   └── README.md                  # Domain setup documentation
├── LICENSE                         # Project license
└── README.md                      # This file
```

## 🎯 Modular Organization

This repository uses a **modular approach** where:
- **Technology stacks** are self-contained (Node.js + PostgreSQL)
- **Common services** are reusable modules (NGINX domain setup)
- **Each module** has its own comprehensive documentation
- **Mix and match** modules based on your project needs

## 🚀 Available Modules

### 🟢 Node.js + PostgreSQL Stack
**Location:** `nodejs-postgresql-stack/`

**Core Components:**
- Node.js v22.0.15 (via NVM)
- PostgreSQL 14 with remote access
- PM2 process manager
- Essential development tools

**Perfect for:**
- REST APIs with PostgreSQL backend
- Full-stack Node.js applications
- Backend services and microservices
- Development and production environments

**Quick Start:**
```bash
cd nodejs-postgresql-stack
sudo ./server_setup.sh        # Install base stack
./post_setup_check.sh         # Validate setup
```

### 🌐 NGINX Domain & SSL Setup
**Location:** `nginx-domain-ssl-setup/`

**Features:**
- Domain configuration with NGINX
- Automatic SSL certificates (Let's Encrypt)
- HTTPS enforcement
- Virtual host setup

**Works with any stack requiring:**
- Custom domain configuration
- SSL/HTTPS setup
- NGINX web server
- Production-ready domain setup

**Quick Start:**
```bash
cd nginx-domain-ssl-setup
./setup_domain.sh            # Configure domain & SSL
```

## 🔧 Usage Patterns

### For Full Web Applications
```bash
# 1. Set up backend infrastructure
cd nodejs-postgresql-stack
sudo ./server_setup.sh

# 2. Configure domain and SSL
cd ../nginx-domain-ssl-setup
./setup_domain.sh

# 3. Validate setup
cd ../nodejs-postgresql-stack
./post_setup_check.sh
```

### For API-Only Services
```bash
# Just the backend stack
cd nodejs-postgresql-stack
sudo ./server_setup.sh
./post_setup_check.sh
```

### For Domain Setup with Any Stack
```bash
# Reusable domain setup
cd nginx-domain-ssl-setup
./setup_domain.sh
```

## 📚 Documentation

Each stack directory contains comprehensive documentation including:
- **Complete tech stack details** (versions, components, configurations)
- **Step-by-step usage instructions** with command examples
- **Prerequisites and system requirements** for each stack
- **Security considerations** and best practices
- **Use case recommendations** and deployment scenarios

## 🔮 Future Module Additions

This modular structure supports easy addition of new components:

### Technology Stacks
- `python-django-mysql-stack/` - Django + MySQL backend
- `laravel-mysql-stack/` - Laravel + MySQL backend  
- `react-nodejs-mongodb-stack/` - MERN stack setup
- `docker-compose-stacks/` - Containerized environments
- `kubernetes-deployments/` - K8s cluster setups

### Reusable Service Modules
- `apache-domain-ssl-setup/` - Apache virtual host + SSL
- `database-backup-scripts/` - Automated database backups
- `monitoring-stack-setup/` - Prometheus + Grafana monitoring
- `redis-cache-setup/` - Redis caching configuration
- `load-balancer-setup/` - HAProxy/NGINX load balancing

## 🎯 Benefits of Modular Organization

- **Technology-specific**: Each stack focuses on core technologies (Node.js + PostgreSQL)
- **Reusable Components**: Common services (NGINX setup) work with any stack
- **Scalable**: Easy to add new stacks and modules without conflicts
- **Maintainable**: Stack-specific monitoring and validation scripts
- **Clear Separation**: Backend stacks separate from frontend/domain configuration
- **Mix and Match**: Combine modules based on project requirements
- **Future-proof**: Easy to add new technologies and service modules

## 🔐 Security Best Practices

- **Firewall Configuration**: Each stack configures appropriate UFW rules
- **SSL Certificates**: Automatic HTTPS setup where applicable
- **Service Security**: Secure default configurations for all services
- **Password Management**: Interactive secure password setup
- **Permission Management**: Proper file and directory permissions

## 🛡️ General Requirements

- **OS**: Ubuntu 18.04+ or Debian 10+ (most stacks)
- **Access**: Root/sudo privileges required
- **Network**: Internet connection for package installation
- **Domain**: Valid domain name (for SSL-enabled stacks)

## 🤝 Contributing New Modules

### For Technology Stacks:
1. Use descriptive folder names: `technology-database-stack`
2. Include core scripts: setup, monitoring/validation
3. Focus on the core technology stack (avoid mixing web server config)
4. Create comprehensive README with stack-specific details

### For Service Modules:
1. Use descriptive names: `service-purpose-setup` (e.g., `nginx-domain-ssl-setup`)
2. Make modules reusable across different stacks
3. Include clear documentation about compatibility
4. Test with multiple technology stacks

### General Guidelines:
- Test thoroughly in multiple environments
- Follow existing security practices
- Keep modules focused and single-purpose
- Provide clear usage examples

## 📄 License

This project is licensed under the terms specified in the LICENSE file.

---

**⚠️ Important:** Always test scripts in non-production environments first. Each stack includes specific requirements and security considerations.