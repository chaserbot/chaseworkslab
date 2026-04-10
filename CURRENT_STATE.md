# Current state

Last updated: 2026-04-10

Quick snapshot of what is running, what is stable, and any known issues.
Update this after significant changes.

## Overall status

**Yellow** — Core media services running and active on Mac Mini #1. Proxmox cluster formed (pve1/pve2/pve3 joined; no HA configured; no production workloads yet). pve1 front-door stack defined and ready to deploy (AdGuard Home, NPM, Homepage). Several MM1 services running but compose files not yet committed to git.

## What is running

| Service | Status | Host | Notes |
| ------- | ------ | ---- | ----- |
| Sonarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Radarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Prowlarr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| qBittorrent | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Overseerr | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Audiobookshelf | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Jellyfin | Running | Ace Magician CK10 (`10.27.27.33`) | Not yet Dockerized; hardware transcoding unverified |
| Uptime Kuma | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Paperless-ngx | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Pi-hole | Running | Mac Mini #1 UTM VM (`10.27.27.193`) | Interim DNS; fragile — tied to macOS host; being replaced by AdGuard Home |
| pve1 | Clustered | `10.27.27.101` | Joined to cluster; no HA; no production workloads |
| pve2 | Clustered | `10.27.27.102` | Joined to cluster; no HA; no production workloads |
| pve3 | Clustered | `10.27.27.103` | Joined to cluster; no HA; no production workloads |
| AdGuard Home | Ready to deploy | pve1 CT110 (`10.27.27.110`) | Community script; see `lxc/pve1/adguard-home/README.md` |
| Nginx Proxy Manager | Ready to deploy | pve1 CT101 (`10.27.27.111`) | Community script; see `lxc/pve1/nginx-proxy-manager/README.md` |
| Homepage | Ready to deploy | pve1 CT102 (`10.27.27.112`) | Community script; see `lxc/pve1/homepage/README.md` |
| Ollama | Not deployed | — | Planned: Proxmox LXC or VM |
| Open WebUI | Not deployed | — | Planned: same host as Ollama |
| n8n | Not deployed | — | Planned: pve3 LXC |
| Grafana | Not deployed | — | Planned: pve3 LXC |
| Prometheus | Not deployed | — | Planned: pve3 LXC |

## Known issues

- **Proxmox cluster formed but idle**: pve1/pve2/pve3 clustered; no HA; no LXCs running. NFS storage mounted from MM1 (`littlepeggy`, `bigpeggy`). Testing only so far.
- **Pi-hole on UTM VM**: fragile — tied to Mac Mini #1 macOS host, no HA. Replacement (AdGuard Home on pve1) is ready to deploy.
- **Docker Compose files not in git**: arr stack, Uptime Kuma, Paperless-ngx all running but compose files not yet sanitized and committed.
- **Jellyfin**: not Dockerized, media path to Pegasus DAS not confirmed, Intel Quick Sync hardware transcoding not verified.
- **Flat network**: all devices on `10.27.27.0/24` — no VLANs.
- **`chaseworkslab.com`**: owned but DNS not configured — no internal service resolution yet.
- **LLM stack**: not yet deployed — architecture planned, repo scaffolded.
- **Monitoring stack**: Uptime Kuma only — Grafana/Prometheus not yet deployed.

## Last stable configuration

Mac Mini #1 (`10.27.27.22`) running arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr, Audiobookshelf) + Uptime Kuma + Paperless-ngx via Docker Compose. Media stored on Pegasus DAS (Thunderbolt-attached). Jellyfin running bare on Ace Magician CK10. Pi-hole as UTM VM at `10.27.27.193` handling DNS for all local devices.

## Recent changes

- 2026-04-10: Replaced custom create-lxc.sh scripts with per-service READMEs referencing community helper scripts; removed shared Docker LXC approach; AdGuard Home (CT110), NPM (CT101), Homepage (CT102) each get their own LXC
- 2026-04-10: pve1 front-door stack fully defined — AdGuard Home, NPM, Homepage ready to deploy via community scripts
- 2026-04-10: Proxmox cluster formed — pve1/pve2/pve3 joined; no HA; NFS storage (LittlePeggy + BigPeggy) mounted on all nodes
- 2026-03-30: Consolidated 10 standalone repos into monorepo; homelab-context merged into root docs
