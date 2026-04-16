#!/usr/bin/env bash
set -euo pipefail

sudo cp /etc/postgresql/12/main/postgresql.conf /etc/postgresql/12/main/postgresql.conf.bak
sudo cp /etc/postgresql/12/main/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf.bak

sudo sed -i "s/^#\?listen_addresses\s*=.*/listen_addresses = '*'/" /etc/postgresql/12/main/postgresql.conf

if ! sudo grep -q "^host    all             all             0.0.0.0/0               md5$" /etc/postgresql/12/main/pg_hba.conf; then
  echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf > /dev/null
fi

sudo systemctl restart postgresql
sudo systemctl status postgresql --no-pager -l | sed -n '1,20p'
echo '---'
sudo ss -ltnp | grep 5432 || true
