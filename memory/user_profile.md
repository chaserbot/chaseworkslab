---
name: User profile
description: Who Chase is, his homelab environment, and how he prefers to work
type: user
---

Chase Cook — homelab owner and operator. Practical, conversational style. Prefers clear explanations of infrastructure changes over jargon-heavy precision.

## Environment

- 3-node Proxmox cluster (pve1/2/3) on 2014 Mac Mini A1347s
- Mac Mini #1 (MM1) as NAS brain — macOS, Pegasus DAS, NFS server
- Ace Magician CK10 as dedicated Jellyfin server (Windows)
- docker-arr VM on pve2 running the full arr stack via Docker Compose
- Tailscale subnet router on pve1 for remote access; split DNS via AdGuard Home
- All services on flat `10.27.27.0/24` network; static IPs via UniFi DHCP reservations

## Working style

- Authors configs locally in VS Code, commits to this monorepo, deploys to hosts intentionally
- Prefers community helper scripts for Proxmox LXC deploys
- Uses `.env.example` pattern — secrets never in git
- Wants step-by-step rollout plans for risky changes
- Wants docs updated after meaningful changes (CURRENT_STATE, DECISIONS, STACK, NEXT_STEPS, inventory)

## What to check first

- `inventory/README.md` for IPs and ports before writing any config
- `CURRENT_STATE.md` for what is actually running vs planned
- `NEXT_STEPS.md` for priorities and in-progress work
