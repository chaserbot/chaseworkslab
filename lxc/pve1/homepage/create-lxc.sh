#!/usr/bin/env bash
# Create and provision the Homepage dashboard LXC on pve1.
# Run this script on pve1: bash create-lxc.sh
set -euo pipefail

CTID=102
HOSTNAME="homepage"
IP="10.27.27.112"
GW="10.27.27.1"
MEMORY=256
CORES=1
DISK=2
TEMPLATE="local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
REPO="https://github.com/chaserbot/chaseworkslab.git"

echo "==> Creating LXC ${CTID} (${HOSTNAME}) at ${IP}"
pct create ${CTID} ${TEMPLATE} \
  --hostname ${HOSTNAME} \
  --memory ${MEMORY} \
  --swap 0 \
  --cores ${CORES} \
  --net0 name=eth0,bridge=vmbr0,ip=${IP}/24,gw=${GW} \
  --storage local-lvm \
  --rootfs local-lvm:${DISK} \
  --unprivileged 1 \
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

echo "==> Cloning repo and deploying Homepage"
pct exec ${CTID} -- bash -c "
  git clone ${REPO} /opt/chaseworkslab
  cd /opt/chaseworkslab/lxc/pve1/homepage
  docker compose up -d
"

echo ""
echo "==> Done. Homepage: http://${IP}:3000"
echo "    To update config: pull the repo inside the LXC and restart the container."
echo "    ssh root@${IP}, then: cd /opt/chaseworkslab && git pull && docker compose -f lxc/pve1/homepage/docker-compose.yml restart"
