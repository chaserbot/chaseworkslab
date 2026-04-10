# Claude project guidance

Focus on:
- explaining infra changes clearly
- minimizing risky destructive actions
- proposing step-by-step rollout plans
- updating docs after edits

Assume:
- mixed environment of Mac mini, Proxmox, Docker, SMB mounts, Tailscale
- user prefers practical, conversational explanations

## Inventory — always check this first

**`inventory/README.md` is the canonical reference for:**
- Host IPs and access URLs (MM1, pve1/2/3, CK10, etc.)
- All service ports (Sonarr, Radarr, Prowlarr, Overseerr, qBittorrent, Jellyfin, etc.)
- Storage: LittlePeggy and BigPeggy NFS paths, Proxmox mount points (`/mnt/littlepeggy`, `/mnt/bigpeggy`), and Proxmox storage IDs (`littlepeggy`, `bigpeggy`)
- Planned service targets and Prometheus scrape targets

When writing docker-compose files, Ansible playbooks, LXC configs, or any file that references IPs, ports, or storage paths — **pull values from inventory/README.md, not from memory.**

## Doc maintenance

After any meaningful change to infrastructure or configs, update:
- CURRENT_STATE.md (what changed, new state)
- DECISIONS.md (why the change was made)
- STACK.md (if ports or services changed)
- NEXT_STEPS.md (check off completed items, add follow-ups)
- inventory/README.md (if IPs, ports, hosts, or storage changed)

## Risk posture

- Before destructive operations, confirm with the user
- Prefer additive changes over modifications to working configs
- When proposing a rollback, make it concrete and copy-pasteable
