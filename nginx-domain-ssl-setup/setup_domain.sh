#!/bin/bash

# Prompt for domain name
read -p "Enter your domain (e.g., example.com): " DOMAIN

# Define paths
WEB_ROOT="/var/www/$DOMAIN/html"
NGINX_AVAILABLE="/etc/nginx/sites-available/$DOMAIN"
NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

# Step 1: Create the website directory
sudo mkdir -p "$WEB_ROOT"

# Step 2: Set ownership
sudo chown -R "$USER":"$USER" "/var/www/$DOMAIN"

# Step 3: Set permissions
sudo chmod -R 755 "/var/www/$DOMAIN"

# Step 4: Create a simple index.html file
cat <<EOF | sudo tee "$WEB_ROOT/index.html" > /dev/null
<html>
    <head>
        <title>Welcome to $DOMAIN!</title>
    </head>
    <body>
        <h1>Success! The $DOMAIN server block is working!</h1>
    </body>
</html>
EOF

# Step 5: Create NGINX server block config if not exists
if [ ! -f "$NGINX_AVAILABLE" ]; then
    cat <<EOF | sudo tee "$NGINX_AVAILABLE" > /dev/null
server {
    listen 80;
    listen [::]:80;

    root /var/www/$DOMAIN/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $DOMAIN www.$DOMAIN;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
else
    echo "NGINX config already exists: $NGINX_AVAILABLE"
fi

# Step 6: Create symlink in sites-enabled if not exists
if [ ! -L "$NGINX_ENABLED" ]; then
    sudo ln -s "$NGINX_AVAILABLE" "$NGINX_ENABLED"
else
    echo "Symlink already exists: $NGINX_ENABLED"
fi

# Step 7: Reload NGINX
sudo nginx -t && sudo systemctl reload nginx

# Step 8: Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    echo "Certbot not found. Installing certbot..."
    sudo apt update
    sudo apt install certbot python3-certbot-nginx -y
fi

# Step 9: Obtain SSL certificate
sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN"
