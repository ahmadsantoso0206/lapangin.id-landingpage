#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/var/www/lapangin.id"
NGINX_AVAILABLE="/etc/nginx/sites-available/lapangin.id"
NGINX_ENABLED="/etc/nginx/sites-enabled/lapangin.id"
UPLOAD_ROOT="$HOME/lapangin-ci"
UPLOAD_APP_DIR="$UPLOAD_ROOT/landing-page"

echo "==> Checking runtime"
command -v rsync >/dev/null 2>&1 || { echo "rsync is required on server"; exit 1; }
command -v nginx >/dev/null 2>&1 || { echo "nginx is required on server"; exit 1; }

echo "==> Preparing directories"
sudo mkdir -p "$APP_DIR"

echo "==> Syncing landing page files"
sudo rsync -a --delete \
  --exclude .git \
  --exclude .github \
  --exclude deploy \
  "$UPLOAD_APP_DIR"/ "$APP_DIR"/

echo "==> Installing nginx config"
sudo cp "$UPLOAD_APP_DIR/lapangin.nginx.conf" "$NGINX_AVAILABLE"
sudo ln -sf "$NGINX_AVAILABLE" "$NGINX_ENABLED"
sudo nginx -t
sudo systemctl reload nginx

echo "==> Setting permissions"
sudo chown -R www-data:www-data "$APP_DIR"
sudo find "$APP_DIR" -type d -exec chmod 755 {} \;
sudo find "$APP_DIR" -type f -exec chmod 644 {} \;

echo "==> Deployment finished"
