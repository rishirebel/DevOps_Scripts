#!/bin/bash

echo "🔍 Verifying installed software and services..."

# Show versions
echo "-----------------------------"
echo "✅ Node.js version:"
node -v

echo "-----------------------------"
echo "✅ NPM version:"
npm -v

echo "-----------------------------"
echo "✅ PM2 version:"
pm2 -v

echo "-----------------------------"
echo "✅ PostgreSQL version:"
psql --version

echo "-----------------------------"
echo "✅ NGINX version:"
nginx -v

echo "✅ Checking service status..."

echo "-----------------------------"
systemctl is-active nginx && echo "🟢 NGINX is running." || echo "🔴 NGINX is NOT running."

echo "-----------------------------"
systemctl is-active postgresql && echo "🟢 PostgreSQL is running." || echo "🔴 PostgreSQL is NOT running."

echo "-----------------------------"
pgrep -x node > /dev/null && echo "🟢 Node.js process running." || echo "⚠️ No active Node.js process found."

echo "-----------------------------"
echo "🧱 Configuring UFW Firewall (if installed)..."

if command -v ufw &>/dev/null; then
  sudo ufw allow OpenSSH
  sudo ufw allow 'Nginx Full'
  sudo ufw --force enable
  echo "✅ UFW is enabled and configured."
else
  echo "⚠️ UFW is not installed. Skipping firewall setup."
fi

echo "-----------------------------"
echo "🚀 Setting up PM2 to auto-start on boot..."
pm2 startup systemd -u $USER --hp $HOME
pm2 save

echo "-----------------------------"
echo "🎉 Post-setup check completed successfully!"

echo "
👉 Suggested Next Steps:
- Place your Node.js project in a suitable directory
- Start your app with: pm2 start server.js --name your-app-name
- View logs: pm2 logs
- Secure your PostgreSQL and app configs
- Add HTTPS via Certbot (if not done)
"