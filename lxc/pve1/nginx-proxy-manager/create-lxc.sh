#!/usr/bin/env bash
# Deploy Nginx Proxy Manager LXC on pve1 using the community helper script.
# Run this on pve1: bash create-lxc.sh
#
# The community script handles template selection, OS setup, and NPM installation
# interactively. When prompted:
#   - IP: 10.27.27.111
#   - Gateway: 10.27.27.1
#   - CT ID: 101
#
# After deploy, admin UI: http://10.27.27.111:81
# Default credentials: admin@example.com / changeme  (change immediately)
#
# Source: https://github.com/community-scripts/ProxmoxVE

bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/nginxproxymanager.sh)"
