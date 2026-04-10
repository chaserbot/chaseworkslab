# Current state

Last updated: 2026-04-10

Quick snapshot of what is running, what is stable, and any known issues.
Update this after significant changes.

## Overall status

**Yellow** — Core media services running and active on Mac Mini #1. Proxmox cluster formed (pve1/pve2/pve3 joined; no HA configured; no production workloads yet). Several services running but not yet committed to git. LLM and monitoring stacks not yet deployed.

## What is running

| Service | Status | Host | Notes |
|---------|--------|------|-------|
| Sonarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Radarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Prowlarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| qBittorrent | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Overseerr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Audiobookshelf | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Jellyfin | Running | Ace Magician CK10 | Not yet Dockerized; no static IP assigned; hardware transcoding unverified |
| Uptime Kuma | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Paperless-ngx | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Pi-hole | Running | Mac Mini #1 UTM VM (`10.27.27.193`) | Handles DNS for all local devices; fragile — tied to macOS host, no HA |
| pve1 | Clustered | `10.27.27.101` | Joined to cluster; no HA; no production workloads |
| pve2 | Clustered | `10.27.27.102` | Joined to cluster; no HA; no production workloads |
| pve3 | Clustered | `10.27.27.103` | Joined to cluster; no HA; no production workloads |
| Ollama | Not deployed | — | Planned: Proxmox LXC or VM |
| Open WebUI | Not deployed | — | Planned: same host as Ollama |
| n8n | Not deployed | — | Planned: Proxmox LXC |
| Grafana | Not deployed | — | Planned: Proxmox cluster |
| Prometheus | Not deployed | — | Planned: Proxmox cluster |

## Known issues

- **Proxmox cluster formed but idle**: pve1/pve2/pve3 clustered; no HA configured; no LXCs running. NFS storage mounted from MM1 (`littlepeggy`, `bigpeggy`). Testing only so far.
- **Pi-hole on UTM VM**: fragile — tied to Mac Mini #1 macOS host, no HA. Migration to Proxmox LXC is planned (Track T2).
- **Docker Compose files not in git**: arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr, Audiobookshelf), Jellyfin, Uptime Kuma, Paperless-ngx all running but compose files not yet sanitized and committed.
- **Jellyfin**: no static IP assigned, not Dockerized, media path to Pegasus DAS not confirmed, Intel Quick Sync hardware transcoding not verified.
- **Flat network**: all devices on `10.27.27.0/24` — no VLANs.
- **`chaseworkslab.com`**: owned but DNS not configured — no internal service resolution yet.
- **LLM stack**: not yet deployed — architecture planned, repo scaffolded.
- **Monitoring stack**: Uptime Kuma only — Grafana/Prometheus not yet deployed.

## Last stable configuration

Mac Mini #1 (`10.27.27.22`) running arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr, Audiobookshelf) + Uptime Kuma + Paperless-ngx via Docker Compose. Media stored on Pegasus DAS (Thunderbolt-attached). Jellyfin running bare on Ace Magician CK10. Pi-hole as UTM VM at `10.27.27.193` handling DNS for all local devices.

## Recent changes

- 2026-04-10: pve1 front-door stack scaffolded — AdGuard Home (CT100), Nginx Proxy Manager (CT101), Homepage (CT102) compose files + create scripts committed; ready to deploy
- 2026-04-10: Proxmox cluster formed — pve1/pve2/pve3 joined; no HA; NFS storage (LittlePeggy + BigPeggy) mounted on all nodes; no production workloads yet
- 2026-03-30: Consolidated 10 standalone repos into monorepo; homelab-context merged into root docs (see DECISIONS.md)
- 2026-03-26: homelab-context per-tool context files written for all services
