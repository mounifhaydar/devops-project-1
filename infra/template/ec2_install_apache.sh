#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y python3 python3-pip git curl

cd /home/ubuntu
if [ ! -d /home/ubuntu/python-mysql-db-proj-1 ]; then
  git clone https://github.com/mounifhaydar/python-mysql-db-proj-1.git
fi

cd /home/ubuntu/python-mysql-db-proj-1
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

export PORT=5000
export FLASK_ENV=production
nohup python3 app.py > /var/log/python-api.log 2>&1 &

sleep 10
curl --retry 10 --retry-connrefused --retry-delay 2 http://127.0.0.1:5000/health || true