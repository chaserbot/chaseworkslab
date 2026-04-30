# Current state

Last updated: 2026-04-30

Quick snapshot of what is running, what is stable, and any known issues.
Update this after significant changes.

## Overall status

**Yellow** — Core media services running on Mac Mini #1. Proxmox cluster operational. pve1 front-door stack live: AdGuard Home and Nginx Proxy Manager deployed and active. Jellyfin accessible at `jellyfin.chaseworkslab.com`. pve1 is Tailscale subnet router with split DNS — all `*.chaseworkslab.com` names resolve on the tailnet. Remaining services need DNS + NPM entries added (see `lxc/pve1/dns-proxy-entries.md`). Homepage LXC not yet deployed. Several MM1 Docker Compose files not yet committed to git.

## What is running

| Service | Status | Host | Notes |
| ------- | ------ | ---- | ----- |
| Sonarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| Radarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| Prowlarr | Running | docker-arr VM (`10.27.27.47`) | Docker Compose; see `arr/docker-compose.yml` |
| qBittorrent | Running | docker-arr VM (`10.27.27.47`) | VPN via Gluetun (ProtonVPN kill switch) |
| Seerr | Running | docker-arr VM (`10.27.27.47`) | Replaces Overseerr; media request UI |
| FlareSolverr | Running | docker-arr VM (`10.27.27.47`) | Cloudflare bypass for Prowlarr |
| cAdvisor | Running | docker-arr VM (`10.27.27.47`) | Docker container metrics; port 8085 |
| Audiobookshelf | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Jellyfin | Running | Ace Magician CK10 (`10.27.27.33`) | Not yet Dockerized; hardware transcoding unverified |
| Uptime Kuma | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Paperless-ngx | Running | Mac Mini #1 (`10.27.27.22`) | Docker Compose; compose file not yet in git |
| Pi-hole | Running | Mac Mini #1 UTM VM (`10.27.27.193`) | Interim DNS; fragile — tied to macOS host; being replaced by AdGuard Home |
| pve1 | Clustered | `10.27.27.101` | Joined to cluster; no HA |
| pve2 | Clustered | `10.27.27.102` | Joined to cluster; no HA |
| pve3 | Clustered | `10.27.27.103` | Joined to cluster; no HA |
| AdGuard Home | Running | pve1 CT110 (`10.27.27.110`) | DNS rewrites active; individual entries per service → `10.27.27.111`; router DHCP DNS updated |
| Nginx Proxy Manager | Running | pve1 CT101 (`10.27.27.111`) | Reverse proxy active; `jellyfin.chaseworkslab.com` live; more entries to add |
| Homepage | Config ready; deploy pending | pve1 CT102 (`10.27.27.112`) | Config files in `lxc/pve1/homepage/config/`; full service layout built incl. widgets, Proxmox API token auth, UniFi widget |
| Prometheus | Config ready; deploy pending | pve3 LXC (`10.27.27.130`) | Scrape config in `monitoring/prometheus/prometheus.yml`; jobs labeled for readable Grafana dashboards |
| pve_exporter | Running | pve3 LXC (`10.27.27.139`) | Installed via community script; scrapes pve1/2/3 API; see `monitoring/prometheus/pve-exporter-setup.md` |
| Exportarr | Planned | docker-arr VM (`10.27.27.47`) | Compose sidecars for Radarr (`9707`), Sonarr (`9708`), Prowlarr (`9709`); API keys come from `arr/.env` |
| Blackbox exporter | Planned | pve3 LXC (`10.27.27.136`) | HTTP/TCP probes configured in Prometheus; config template at `monitoring/blackbox/blackbox.yml` |
| qbittorrent-exporter | Pending config | pve3 LXC (`10.27.27.137`) | Config template at `monitoring/qbittorrent-exporter/qbittorrent-exporter.env`; needs qBT password |
| Grafana dashboard JSON | Config ready | `monitoring/grafana/dashboards/chaseworkslab-overview.json` | Uploadable ChaseWorksLab overview dashboard for Prometheus metrics |
| Ollama | Not deployed | — | Planned: Proxmox LXC or VM |
| Open WebUI | Not deployed | — | Planned: same host as Ollama |
| n8n | Not deployed | — | Planned: pve3 LXC |
| Grafana | Not deployed | — | Planned: pve3 LXC |

## Known issues

- **Pi-hole on UTM VM**: still running at `10.27.27.193` — router DNS has been updated to AdGuard Home, but UTM VM not yet shut down. Safe to decommission.
- **Docker Compose files not in git**: Uptime Kuma and Paperless-ngx still running on MM1 but compose files not yet committed.
- **Jellyfin**: not Dockerized, media path to Pegasus DAS not confirmed, Intel Quick Sync hardware transcoding not verified.
- **Flat network**: all devices on `10.27.27.0/24` — no VLANs.
- **NPM entries incomplete**: only Jellyfin proxied so far; see `lxc/pve1/dns-proxy-entries.md` for full list to build out.
- **Homepage LXC**: config files ready but LXC not yet deployed (CT102, `10.27.27.112`).
- **LLM stack**: not yet deployed — architecture planned, repo scaffolded.
- **Monitoring stack**: Prometheus config built; Grafana dashboard JSON ready for import; Grafana not yet deployed; Exportarr sidecars need Arr API keys in docker-arr `.env`; Blackbox LXC not yet deployed; qbittorrent-exporter needs credentials configured in its LXC.
- **Homepage services.yaml**: Planned section has stale IPs for Prometheus (was `.131`, now `.130`) and Grafana/n8n — update once those LXCs are assigned IPs.

## Last stable configuration

Arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Seerr, FlareSolverr) running on docker-arr Proxmox VM via Docker Compose with Gluetun VPN. Storage on BigPeggy NFS. MM1 still hosts Audiobookshelf, Uptime Kuma, and Paperless-ngx. Jellyfin running bare on Ace Magician CK10 at `jellyfin.chaseworkslab.com`. AdGuard Home on pve1 CT110 is the active DNS resolver. NPM on pve1 CT101 is the active reverse proxy. pve1 is Tailscale subnet router with split DNS for `chaseworkslab.com`.

## Recent changes

- 2026-04-30: Added uploadable ChaseWorksLab Grafana overview dashboard JSON at `monitoring/grafana/dashboards/chaseworkslab-overview.json`, targeting the repo's Prometheus jobs and labels with command-center, bare-metal, Proxmox guest, Docker, storage/network, and collapsed deep-dive rows.
- 2026-04-27: pve_exporter setup verified. Guide now uses the working token config and grants `PVEAuditor` to both `prometheus@pve` and `prometheus@pve!prometheus`.
- 2026-04-27: Monitoring plan changed from Scraparr LXC to Exportarr sidecars in the docker-arr VM. Added Blackbox exporter plan at `10.27.27.136:9115` with HTTP/TCP probes for core services.
- 2026-04-27: pve_exporter setup doc corrected to grant `PVEAuditor` to the API token with `--tokens 'prometheus@pve!prometheus'` instead of passing the token ID as a user.
- 2026-04-22: Prometheus scrape config reviewed and refined — CK10 uses default windows_exporter port `9182`; Proxmox node/API jobs have readable `node`/`host` labels; Arr and qBittorrent jobs are documented as credential-dependent.
- 2026-04-22: pve_exporter setup doc updated to use the community `prometheus-pve-exporter` LXC script; config path documented as `/opt/prometheus-pve-exporter/pve.yml`.
- 2026-04-22: Prometheus scrape config built (`monitoring/prometheus/prometheus.yml`) — jobs for node_exporter (pve1/2/3, MM1, docker-arr VM), windows_exporter (CK10), pve_exporter, Arr app metrics, qbittorrent-exporter, cAdvisor. Initial plan used Scraparr; superseded by Exportarr sidecars on 2026-04-27.
- 2026-04-21: Homepage config files built and committed to `lxc/pve1/homepage/config/` — services.yaml (Infrastructure, Media, Arr Stack, Downloads sections with live widgets), settings.yaml, widgets.yaml (greeting, search, datetime, resources), bookmarks.yaml. Proxmox widgets use API token auth. UniFi widget enabled with site name.
- 2026-04-15: Arr stack migrated to docker-arr Proxmox VM (Docker Compose + Gluetun VPN). Seerr replaces Overseerr. FlareSolverr added. Compose file committed to `arr/docker-compose.yml`.
- 2026-04-13: AdGuard Home (CT110) and NPM (CT101) deployed on pve1 and active. Jellyfin proxy entry live at `jellyfin.chaseworkslab.com`. pve1 configured as Tailscale subnet router with split DNS. Router DHCP DNS updated from Pi-hole (`10.27.27.193`) to AdGuard Home (`10.27.27.110`).
- 2026-04-10: Replaced custom create-lxc.sh scripts with per-service READMEs referencing community helper scripts; removed shared Docker LXC approach; AdGuard Home (CT110), NPM (CT101), Homepage (CT102) each get their own LXC
- 2026-04-10: Proxmox cluster formed — pve1/pve2/pve3 joined; no HA; NFS storage (LittlePeggy + BigPeggy) mounted on all nodes
- 2026-03-30: Consolidated 10 standalone repos into monorepo; homelab-context merged into root docs
