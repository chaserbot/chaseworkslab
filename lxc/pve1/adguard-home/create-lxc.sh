#!/usr/bin/env bash
# Create and provision the AdGuard Home LXC on pve1.
# Run this script on pve1: bash create-lxc.sh
set -euo pipefail

CTID=100
HOSTNAME="adguard-home"
IP="10.27.27.110"
GW="10.27.27.1"
MEMORY=512
CORES=2
DISK=4
TEMPLATE="local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"

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
  --features nesting=1,keyctl=1 \
  --onboot 1

pct start ${CTID}
echo "==> Waiting for LXC to boot..."
sleep 5

echo "==> Updating packages"
pct exec ${CTID} -- bash -c "apt-get update -qq && apt-get upgrade -y -qq"

echo "==> Disabling systemd-resolved DNS stub (frees port 53)"
pct exec ${CTID} -- bash -c "
  sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
  echo 'DNSStubListener=no' >> /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
"

echo "==> Installing Docker"
pct exec ${CTID} -- bash -c "
  apt-get install -y -qq curl ca-certificates
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable' \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
  systemctl enable docker
"

echo "==> Deploying AdGuard Home"
pct exec ${CTID} -- bash -c "mkdir -p /opt/adguard-home"
pct push ${CTID} docker-compose.yml /opt/adguard-home/docker-compose.yml
pct exec ${CTID} -- bash -c "cd /opt/adguard-home && docker compose up -d"

echo ""
echo "==> Done. AdGuard Home initial setup: http://${IP}:3000"
echo "    Complete setup wizard, then web UI moves to http://${IP}"
echo "    After setup: update router DNS from 10.27.27.193 to ${IP}"
