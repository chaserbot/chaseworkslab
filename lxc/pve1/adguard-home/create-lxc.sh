#!/usr/bin/env bash
# Deploy AdGuard Home LXC on pve1 using the community helper script.
# Run this on pve1: bash create-lxc.sh
#
# The community script handles template selection, OS setup, and AdGuard Home
# installation interactively. When prompted:
#   - IP: 10.27.27.110
#   - Gateway: 10.27.27.1
#   - CT ID: 110
#
# Source: https://github.com/community-scripts/ProxmoxVE

bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/adguard.sh)"
