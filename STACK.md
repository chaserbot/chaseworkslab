# Stack

Complete inventory of services, tools, and ports running in the homelab.
Update this file whenever a service is added, removed, or its port changes.

## Infrastructure

| Component | Role | IP | Notes |
|-----------|------|----|-------|
| Luxul ABR-5000 | Router / gateway | 10.27.27.1 | DHCP server; DNS points all clients to Pi-hole |
| Luxul switch | Layer 2 switching | 10.27.27.3 | |
| Archer AX1800 | AP (indoor) | 10.27.27.5 | |
| TP-Link EAP225 Outdoor | AP (outdoor) | 10.27.27.6 | |
| Lutron Caseta Hub | Smart home | 10.27.27.7 | |
| MacBook Pro (M3) | Daily driver — company-issued | 10.27.27.11 | |
| Mac Mini #1 (macOS, A1347) | Main server / NAS brain | 10.27.27.22 | Runs arr stack, Uptime Kuma, Paperless-ngx, Pi-hole UTM VM; Pegasus DAS attached via Thunderbolt |
| Ace Magician CK10 | Jellyfin media server | TBD | i7-1081U, 16GB RAM; static IP not yet assigned |
| ChaseWorksLab NAS | TrueNAS — future build | 10.27.27.27 | Not yet built |
| Pi-hole (UTM VM) | DNS / ad blocking | 10.27.27.193 | Runs on Mac Mini #1; migration to Proxmox LXC planned (Track T2) |
| pve1 (Mac Mini #2, A1347) | Proxmox Node 1 | 10.27.27.31 | Post-install complete; not yet clustered |
| pve2 (Mac Mini #3, A1347) | Proxmox Node 2 | 10.27.27.32 | Post-install complete; not yet clustered |
| pve3 (Mac Mini #4, A1347) | Proxmox Node 3 | 10.27.27.33 | Post-install complete; not yet clustered |
| LittlePeggy (Pegasus 2 R8) | DAS / NFS storage | — | Thunderbolt 2, attached to Mac Mini #1; ~2,500 MB/s theoretical |
| BigPeggy (Pegasus 3 R8) | DAS / NFS storage | — | Thunderbolt 3, daisy-chained to LittlePeggy |
| Tailscale | VPN / zero-trust networking | — | Not yet deployed; planned for remote access |

## Network

- **Subnet**: `10.27.27.0/24`
- **All devices**: static IPs via DHCP reservations on Luxul ABR-5000
- **DNS**: Pi-hole at `10.27.27.193` (router pushes this to all DHCP clients)
- **Domain**: `chaseworkslab.com` — owned; DNS not yet configured
  - Plan: internal `.chaseworkslab.com` resolution via Pi-hole local DNS records (e.g., `proxmox.chaseworkslab.com` → `10.27.27.31`)
- **VLANs**: none yet — flat network; segmentation deferred until Proxmox cluster is stable

## Services and ports

| Service | Folder | Port(s) | Host | Status | Notes |
|---------|--------|---------|------|--------|-------|
| Sonarr | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | TV show automation |
| Radarr | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Movie automation |
| Prowlarr | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Indexer management for Sonarr/Radarr |
| qBittorrent | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Torrent download client |
| Overseerr | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | User-facing media request UI |
| Audiobookshelf | arr/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Audiobook / podcast server |
| Jellyfin | docker/ | TBD | Ace Magician CK10 | Running | Media server; not yet Dockerized; static IP TBD |
| Uptime Kuma | docker/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Uptime / health check monitoring |
| Paperless-ngx | docker/ | TBD | Mac Mini #1 (`10.27.27.22`) | Running | Document management |
| Pi-hole | lxc/ | 53 (DNS), 80 (admin UI) | `10.27.27.193` | Running | Ad blocking + local DNS; admin at `http://10.27.27.193/admin` |
| Open WebUI | llm/ | TBD | TBD | Not deployed | LLM chat frontend |
| Ollama | llm/ | TBD | TBD | Not deployed | Local LLM inference backend |
| n8n | llm/ | TBD | TBD | Not deployed | Automation / agent orchestration |
| Grafana | monitoring/ | TBD | TBD | Not deployed | Dashboards |
| Prometheus | monitoring/ | TBD | TBD | Not deployed | Metrics scraping and storage |
| Node Exporter | monitoring/ | TBD | Each Proxmox node + Mac Mini | Not deployed | Per-host system metrics |

## Tools

| Tool | Purpose | Installed on |
|------|---------|-------------|
| Docker + Compose | Container runtime | Mac Mini #1; planned for Proxmox LXCs |
| Ansible | Config management | Mac Mini #1 (control node) |
| UTM | macOS VM host | Mac Mini #1 (hosts Pi-hole VM) |
| fzf | Fuzzy finder | All machines (via dotfiles) |
| eza | ls replacement | All machines (via dotfiles) |
| Oh My Zsh + Powerlevel10k | Shell | macOS only (via dotfiles) |
