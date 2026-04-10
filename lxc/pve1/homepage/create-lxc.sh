#!/usr/bin/env bash
# Deploy Homepage LXC on pve1 using the community helper script.
# Run this on pve1: bash create-lxc.sh
#
# The community script handles template selection, OS setup, and Homepage installation
# interactively. When prompted:
#   - IP: 10.27.27.112
#   - Gateway: 10.27.27.1
#   - CT ID: 102
#
# After deploy, Homepage is accessible at: http://10.27.27.112:3000
# Config files live inside the LXC at: /opt/homepage/config/
#
# Source: https://github.com/community-scripts/ProxmoxVE

bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/homepage.sh)"
