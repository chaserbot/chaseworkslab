---
name: Homepage config
description: Homepage dashboard config files are committed to repo; LXC not yet deployed; key design decisions
type: project
---

Homepage config files are fully built and committed to `lxc/pve1/homepage/config/`. The LXC itself (CT102, `10.27.27.112`) has not yet been deployed.

**Why:** Author configs locally in repo first, then copy to LXC on deploy — consistent with established pattern.

**How to apply:** When working on Homepage, edit files in `lxc/pve1/homepage/config/`. Deploy by copying to `/opt/homepage/config/` on the LXC.

## Config files

- `services.yaml` — live service widgets (Infrastructure, Media, Arr Stack, Downloads); Documents/Monitoring/Planned sections commented out pending deployment
- `settings.yaml` — dark theme, slate color, clean header, section layout definitions
- `widgets.yaml` — greeting, search (Google), datetime, resources (LXC self-stats)
- `bookmarks.yaml` — personal bookmarks
- `.env.example` — all `HOMEPAGE_VAR_*` secrets documented

## Key design details

- Proxmox widgets use API token auth (`HOMEPAGE_VAR_PROXMOX_TOKEN` + `HOMEPAGE_VAR_PROXMOX_TOKEN_SECRET`), not root password
- UniFi widget enabled with site name specified
- `allowInsecure: true` set on Proxmox and UniFi widgets (self-signed certs)
- Secrets injected via `{{HOMEPAGE_VAR_*}}` from `/opt/homepage/config/.env`
- docker-arr VM confirmed at `10.27.27.47`

## Stale items to fix before going live

- Planned section in services.yaml has placeholder IPs for Grafana and n8n (not yet assigned)
- Prometheus IP corrected to `10.27.27.130` (was `.131`)
- Uptime Kuma and Paperless sections commented out — uncomment and set IPs once deployed on pve3
