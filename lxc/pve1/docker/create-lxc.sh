#!/usr/bin/env bash
# Create the shared Docker host LXC on pve1.
# Hosts: Nginx Proxy Manager + Homepage.
# Run this script on pve1: bash create-lxc.sh
set -euo pipefail

CTID=101
HOSTNAME="pve1-docker"
IP="10.27.27.111"
GW="10.27.27.1"
MEMORY=1024
CORES=2
DISK=8
TEMPLATE="local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
REPO="https://github.com/chaserbot/chaseworkslab.git"

echo "==> Creating LXC ${CTID} (${HOSTNAME}) at ${IP}"
# Privileged LXC — required for reliable Docker operation
pct create ${CTID} ${TEMPLATE} \
  --hostname ${HOSTNAME} \
  --memory ${MEMORY} \
  --swap 0 \
  --cores ${CORES} \
  --net0 name=eth0,bridge=vmbr0,ip=${IP}/24,gw=${GW} \
  --storage local-lvm \
  --rootfs local-lvm:${DISK} \
  --unprivileged 0 \
  --features nesting=1 \
  --onboot 1

pct start ${CTID}
echo "==> Waiting for LXC to boot..."
sleep 5

echo "==> Updating packages"
pct exec ${CTID} -- bash -c "apt-get update -qq && apt-get upgrade -y -qq"

echo "==> Installing Docker and git"
pct exec ${CTID} -- bash -c "
  apt-get install -y -qq curl ca-certificates git
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable' \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
  systemctl enable docker
"

echo "==> Cloning chaseworkslab repo"
pct exec ${CTID} -- bash -c "git clone ${REPO} /opt/chaseworkslab"

echo "==> Starting Nginx Proxy Manager"
pct exec ${CTID} -- bash -c "
  cd /opt/chaseworkslab/docker/nginx-proxy-manager
  cp .env.example .env
  docker compose up -d
"

echo "==> Starting Homepage"
pct exec ${CTID} -- bash -c "
  cd /opt/chaseworkslab/docker/homepage
  docker compose up -d
"

echo ""
echo "==> Done."
echo "    NPM admin UI: http://${IP}:81  (default: admin@example.com / changeme)"
echo "    Homepage:     http://${IP}:3000"
echo ""
echo "    Change NPM credentials immediately after first login."
echo "    To update services: ssh root@${IP}, cd /opt/chaseworkslab, git pull, docker compose restart"
