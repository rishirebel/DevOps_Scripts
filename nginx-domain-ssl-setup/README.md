# NGINX Domain & SSL Setup

Universal domain configuration script for NGINX with automatic SSL certificate management. This script can be used with any server stack that requires domain setup and HTTPS enforcement.

## 🌐 What This Script Does

### Domain Configuration
- Creates proper directory structure for your domain
- Sets up NGINX virtual host (server block)
- Configures both www and non-www domain handling
- Sets appropriate file permissions and ownership

### SSL Certificate Management
- Installs Certbot if not already present
- Obtains Let's Encrypt SSL certificates automatically
- Configures automatic HTTPS redirection
- Sets up certificate auto-renewal

### Directory Structure Created
```
/var/www/yourdomain.com/
└── html/
    └── index.html (sample file)
```

## 📋 Script Details

### setup_domain.sh
**Purpose**: Complete domain and SSL setup for any NGINX-based stack

**Features:**
- **Interactive domain input** - Prompts for your domain name
- **Directory creation** - Creates `/var/www/domain/html` structure
- **Permission management** - Sets proper ownership and permissions
- **NGINX configuration** - Creates virtual host configuration
- **SSL automation** - Handles Let's Encrypt certificate installation
- **Sample content** - Creates basic index.html for testing

**NGINX Configuration:**
- Listens on ports 80 (HTTP) and 443 (HTTPS)
- Supports both www and non-www subdomains
- Automatically redirects HTTP to HTTPS
- Serves files from `/var/www/domain/html`

## 🚀 Usage

### Prerequisites
- NGINX installed and running
- Domain DNS A record pointing to server IP
- Ports 80 and 443 accessible from internet
- Root/sudo privileges (for file creation and NGINX config)

### Command
```bash
./setup_domain.sh
```

### Interactive Process
1. **Domain Input**: Enter your domain (e.g., `example.com`)
2. **Directory Creation**: Script creates web directory structure
3. **NGINX Configuration**: Virtual host setup
4. **SSL Certificate**: Automatic Let's Encrypt installation
5. **Verification**: Test your domain with HTTPS

## 🔧 What Gets Configured

### NGINX Virtual Host
```nginx
server {
    listen 80;
    listen [::]:80;
    
    root /var/www/yourdomain.com/html;
    index index.html index.htm;
    
    server_name yourdomain.com www.yourdomain.com;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### SSL Configuration (Added by Certbot)
- HTTPS enforcement
- HTTP to HTTPS redirection
- SSL certificate auto-renewal
- Secure SSL settings

## 🛡️ Security Features

- **HTTPS Enforcement**: Automatic redirection from HTTP to HTTPS
- **SSL Best Practices**: Certbot applies secure SSL configurations
- **File Permissions**: Proper ownership and permissions for web files
- **Auto-renewal**: SSL certificates automatically renew

## 🔄 Compatibility

This script works with any server stack that uses NGINX:
- **Node.js applications** (with reverse proxy setup)
- **PHP applications** (Laravel, WordPress, etc.)
- **Python applications** (Django, Flask)
- **Static websites**
- **Any NGINX-served content**

## 📝 Common Use Cases

### 1. New Domain Setup
```bash
./setup_domain.sh
# Enter: example.com
# Result: HTTPS-enabled domain ready for your application
```

### 2. Multiple Domains
```bash
./setup_domain.sh  # For domain1.com
./setup_domain.sh  # For domain2.com
# Each domain gets its own configuration
```

### 3. Subdomain Setup
```bash
./setup_domain.sh
# Enter: api.example.com
# Result: Subdomain with SSL configured
```

## ⚠️ Important Notes

### DNS Configuration
Ensure your domain's DNS A record points to your server's IP before running:
```
example.com        A    YOUR_SERVER_IP
www.example.com    A    YOUR_SERVER_IP
```

### Firewall Requirements
Ensure these ports are open:
- **Port 80** (HTTP) - Required for Let's Encrypt validation
- **Port 443** (HTTPS) - Required for SSL traffic

### Certificate Renewal
Certbot automatically sets up certificate renewal. Verify with:
```bash
sudo certbot renew --dry-run
```

## 🔧 Troubleshooting

### Common Issues

1. **DNS not propagated**: Wait for DNS to propagate (up to 24 hours)
2. **Port blocked**: Check firewall settings for ports 80/443
3. **NGINX syntax error**: Run `sudo nginx -t` to check configuration
4. **Certificate failure**: Ensure domain resolves to server IP

### Verification Commands
```bash
# Check NGINX configuration
sudo nginx -t

# Check SSL certificate
sudo certbot certificates

# Test domain resolution
dig yourdomain.com

# Check NGINX virtual hosts
sudo nginx -T | grep server_name
```

## 🔄 Reusability

This script is designed to be:
- **Stack-agnostic**: Works with any NGINX-based setup
- **Repeatable**: Can be run multiple times safely
- **Modular**: Use with different server stacks
- **Scalable**: Easy to add multiple domains

Perfect for use with:
- `nodejs-postgresql-stack`
- `python-django-stack`
- `laravel-php-stack`
- Any custom server configuration