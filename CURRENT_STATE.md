# Current state

Last updated: 2026-09-25

Quick snapshot of what is running, what is stable, and any known issues.
Update this after significant changes.

## Overall status

**Yellow** — Proxmox cluster and core services are reachable. The pve1 front-door stack is live: AdGuard Home, Nginx Proxy Manager, and Homepage CT112 are active. The arr stack runs on the docker-arr VM, Jellyfin runs on CK10, and Uptime Kuma runs on pve1 CT119. Internal HTTP proxy routes work, but HTTPS is not working. Paperless's backend location needs verification, and several stateful services still lack reproducible deployment or restore documentation.

## What is running

| Service | Status | Host | Notes |
| ------- | ------ | ---- | ----- |
| Sonarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| Radarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| Prowlarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| qBittorrent | Running | docker-arr VM (`10.27.27.47`) | VPN via Gluetun (ProtonVPN kill switch) |
| Seerr | Running | docker-arr VM (`10.27.27.47`) | Replaces Overseerr; media request UI |
| FlareSolverr | Running | docker-arr VM (`10.27.27.47`) | Cloudflare bypass for Prowlarr |
| Audiobookshelf | Running | `10.27.27.112:13378` | Backend corrected and confirmed after the 2026-09-25 audit |
| Jellyfin | Running | Ace Magician CK10 (`10.27.27.33`) | Not yet Dockerized; hardware transcoding unverified |
| Uptime Kuma | Running | pve1 CT119 (`10.27.27.119`) | Direct endpoint and HTTP proxy verified 2026-09-25 |
| Paperless-ngx | Needs investigation | Unknown backend | HTTP proxy responds, but the former `10.27.27.22:8000` endpoint does not; inspect NPM |
| Pi-hole | Running | Mac Mini #1 UTM VM (`10.27.27.193`) | Interim DNS; fragile — tied to macOS host; being replaced by AdGuard Home |
| pve1 | Clustered | `10.27.27.101` | Joined to cluster; no HA |
| pve2 | Clustered | `10.27.27.102` | Joined to cluster; no HA |
| pve3 | Clustered | `10.27.27.103` | Joined to cluster; no HA |
| AdGuard Home | Running | pve1 CT110 (`10.27.27.110`) | DNS rewrites active; individual entries per service → `10.27.27.111`; router DHCP DNS updated |
| Nginx Proxy Manager | Running | pve1 CT101 (`10.27.27.111`) | Core HTTP routes verified; internal HTTPS needs repair |
| Homepage | Running | pve1 CT112 (`10.27.27.112`) | Config files in `lxc/pve1/homepage/config/`; full service layout built incl. widgets, Proxmox API token auth, UniFi widget, Glances service widgets, Uptime Kuma widget, and Calibre-Web |
| Ollama | Not deployed | — | Planned: Proxmox LXC or VM |
| Open WebUI | Not deployed | — | Planned: same host as Ollama |
| n8n | Not deployed | — | Planned: pve3 LXC |

## Known issues

- **Pi-hole on UTM VM**: still running at `10.27.27.193` — router DNS has been updated to AdGuard Home, but UTM VM not yet shut down. Safe to decommission.
- **Deployment definitions incomplete**: several stateful services lack a current, sanitized deployment definition or restore procedure in git.
- **Jellyfin**: not Dockerized, media path to Pegasus DAS not confirmed, Intel Quick Sync hardware transcoding not verified.
- **Flat network**: all devices on `10.27.27.0/24` — no VLANs.
- **NPM HTTPS incomplete**: the tested service names route over HTTP, but HTTPS failed for names resolving internally to NPM.
- **Homepage LXC**: running on CT112 (`10.27.27.112`); repository configs are deployed to `/opt/homepage/config/`.
- **HTTPS is not working on internal proxy names**: HTTP proxy routes responded on 2026-09-25, but HTTPS connections to the names resolving to NPM failed. Configure certificates/SSL hosts or document HTTP-only intent.
- **Paperless location unknown**: its proxy responds, but the documented MM1 backend does not. Inspect the live NPM proxy host before changing or rebuilding it.
- **LLM stack**: not yet deployed — architecture planned, repo scaffolded.
- **Metrics stack removed from repo**: The unused metrics configs, dashboards, exporter templates, and Arr metrics sidecars have been removed because they are no longer in use.
- **Homepage services.yaml**: the commented Planned section still has a placeholder for n8n; update it when n8n is deployed.

## Last stable configuration

Arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Seerr, FlareSolverr) running on docker-arr Proxmox VM via Docker Compose with Gluetun VPN. Storage on BigPeggy NFS. Uptime Kuma runs on pve1 CT119. Audiobookshelf is at `10.27.27.112:13378`; Paperless's backend still needs verification. Jellyfin runs bare on Ace Magician CK10. AdGuard Home on pve1 CT110 is the active DNS resolver. NPM on pve1 CT101 is the active HTTP reverse proxy. Homepage runs on pve1 CT112. pve1 is the Tailscale subnet router with split DNS for `chaseworkslab.com`.

## Recent changes

- 2026-09-25: Made documentation synchronization part of the standard workflow: update repository docs, mirror necessary reference changes into the CWL Obsidian vault, then commit and push the Git changes.
- 2026-09-25: Audited repository configuration and documented live endpoints. Confirmed Homepage is pve1 CT112 (`10.27.27.112`), verified the three Proxmox nodes, pve1 front-door services, arr VM, Glances, Uptime Kuma CT119, and Jellyfin; recorded prioritized remediation in `HOMELAB_PUNCH_LIST.md`.
- 2026-09-25: Reconciled current-state documentation around `inventory/README.md`; corrected arr, Audiobookshelf, Uptime Kuma, NPM, and Proxmox overview records and marked Paperless as unknown rather than retaining an unverified address.
- 2026-05-04: Purged unused metrics stack materials from the repo. Removed the config tree, Arr metrics sidecars, metrics-only `.env.example` placeholders, and stale service inventory entries.
- 2026-05-04: Cleaned Homepage monitoring config. `services.yaml` now has Glances service widgets for pve1/pve2/pve3 info, CPU, memory, process, and temperature metrics plus an Uptime Kuma service widget for MM1; `widgets.yaml` and `bookmarks.yaml` were returned to their non-monitoring baseline.
- 2026-04-21: Homepage config files built and committed to `lxc/pve1/homepage/config/` — services.yaml (Infrastructure, Media, Arr Stack, Downloads sections with live widgets), settings.yaml, widgets.yaml (greeting, search, datetime, resources), bookmarks.yaml. Proxmox widgets use API token auth. UniFi widget enabled with site name.
- 2026-04-15: Arr stack migrated to docker-arr Proxmox VM (Docker Compose + Gluetun VPN). Seerr replaces Overseerr. FlareSolverr added. Compose file committed to `arr/docker-compose.yml`.
- 2026-04-13: AdGuard Home (CT110) and NPM (CT101) deployed on pve1 and active. Jellyfin proxy entry live at `jellyfin.chaseworkslab.com`. pve1 configured as Tailscale subnet router with split DNS. Router DHCP DNS updated from Pi-hole (`10.27.27.193`) to AdGuard Home (`10.27.27.110`).
- 2026-04-10: Replaced custom create-lxc.sh scripts with per-service READMEs referencing community helper scripts; removed shared Docker LXC approach; AdGuard Home (CT110), NPM (CT101), Homepage (CT112) each get their own LXC
- 2026-04-10: Proxmox cluster formed — pve1/pve2/pve3 joined; no HA; NFS storage (LittlePeggy + BigPeggy) mounted on all nodes
- 2026-03-30: Consolidated 10 standalone repos into monorepo; homelab-context merged into root docs
