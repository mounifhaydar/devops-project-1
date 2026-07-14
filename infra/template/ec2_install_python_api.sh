#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/ec2_install_apache.log | logger -t user-data -s 2>/dev/console) 2>&1

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get install -y \
  python3 \
  python3-pip \
  python3-venv \
  git \
  curl

cd /home/ubuntu

if [ ! -d /home/ubuntu/python-mysql-db-proj-1 ]; then
  git clone https://github.com/mounifhaydar/python-mysql-db-proj-1.git
fi

cd /home/ubuntu/python-mysql-db-proj-1

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

chown -R ubuntu:ubuntu /home/ubuntu/python-mysql-db-proj-1

export PORT=5000
export FLASK_ENV=production

nohup /home/ubuntu/python-mysql-db-proj-1/venv/bin/python app.py \
  > /home/ubuntu/python-api.log 2>&1 &

sleep 10

curl --retry 10 \
     --retry-connrefused \
     --retry-delay 2 \
     http://127.0.0.1:5000/health || true