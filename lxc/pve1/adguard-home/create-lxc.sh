#!/usr/bin/env bash
# Create and provision the AdGuard Home LXC on pve1.
# Native install — no Docker. AdGuard Home runs as a systemd service.
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
  --features nesting=1 \
  --onboot 1

pct start ${CTID}
echo "==> Waiting for LXC to boot..."
until pct exec ${CTID} -- systemctl is-system-running 2>/dev/null | grep -qE "running|degraded"; do sleep 1; done

echo "==> Updating packages"
pct exec ${CTID} -- bash -c "apt-get update -qq && apt-get upgrade -y -qq && apt-get install -y -qq curl"

echo "==> Freeing port 53 (disabling systemd-resolved stub listener)"
pct exec ${CTID} -- bash -c "
  sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
  echo 'nameserver 1.1.1.1' > /etc/resolv.conf
"

echo "==> Installing AdGuard Home"
pct exec ${CTID} -- bash -c "
  curl -sSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh \
    | sh -s -- -v
"

echo ""
echo "==> Done. AdGuard Home setup wizard: http://${IP}:3000"
echo "    Complete the wizard (set admin password, confirm DNS port 53)."
echo "    Web UI moves to http://${IP} after setup."
echo "    Then update router DNS from 10.27.27.193 to ${IP}."
