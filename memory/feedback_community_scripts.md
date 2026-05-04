---
name: Community scripts for LXC deploys
description: Always prefer Proxmox VE community helper scripts over custom create-lxc.sh scripts for deploying services as LXCs
type: feedback
---

Use the [Proxmox VE community helper scripts](https://community-scripts.org) for deploying services as LXCs. Do not write custom create-lxc.sh scripts.

**Why:** Community scripts always pull a current valid template, handle the full install interactively, and are maintained externally — nothing on our end breaks when upstream templates change. Custom scripts hardcode template version strings that go stale.

**How to apply:** When the user wants to deploy a new service as a Proxmox LXC, recommend the community script install command rather than a custom script. Per-service READMEs document the values to enter at the interactive prompts (CT ID, IP, gateway). This pattern is established across pve1 (AdGuard Home, NPM, Homepage).
