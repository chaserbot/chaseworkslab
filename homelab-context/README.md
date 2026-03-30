# homelab-context

Per-tool context files for use with Claude Code. Each file captures the current state, location, config details, and next steps for a specific tool or service in the ChaseWorksLab homelab.

## Purpose
Claude Code can pull from these files at the start of a session to have accurate, up-to-date context about the homelab — what's running, where it lives, what the plan is. Update these files as the state of the homelab changes.

## Files

| File | What It Covers |
|---|---|
| `proxmox.md` | 3-node Proxmox cluster on Mac Minis — post-install, clustering, storage plans |
| `network.md` | Full network map, IPs, DNS, domain plans |
| `arr-stack.md` | Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr on Mac Mini #1 |
| `jellyfin.md` | Jellyfin media server on Ace Magician CK10 |
| `pihole-dns.md` | Pi-hole DNS on UTM VM → planned migration to Proxmox LXC |
| `docker.md` | Docker Compose standards, all services, gitignore patterns, migration path |
| `monitoring.md` | Uptime Kuma (active) + planned Grafana/Prometheus stack |
| `llm-stack.md` | Planned Ollama + Open WebUI stack, FATFISH connection |

## How to Use with Claude Code
At the start of a Claude Code session, reference the relevant context file(s):

```
Read homelab-context/proxmox.md and use it as context for this session.
```

Or for a multi-service task:
```
Read homelab-context/proxmox.md, homelab-context/network.md, and homelab-context/docker.md before we start.
```

## Keeping These Up to Date
Update the relevant `.md` file whenever:
- A service moves to a new host
- An IP changes
- A service is newly deployed or migrated
- A "next step" is completed
- New hardware is added

Last updated: 2026-03-26
