# Stack

Complete inventory of services, tools, and ports running in the homelab.
Update this file whenever a service is added, removed, or its port changes.

## Infrastructure

| Component | Role | IP | Notes |
|-----------|------|----|-------|
| UniFi UX7 | Router / gateway | 10.27.27.1 | DHCP server; DNS points all clients to AdGuard Home (planned) |
| USW Flex 2.5G 8-port PoE | Core switch (rack) | — | Uplinks to UX7; distributes to all other switches |
| USW Flex 2.5G Mini (4-port) | Desktop switch | — | MacBook Pro M3 Pro + 2017 MacBook Pro |
| USW Lite 8-port PoE | Server switch | — | MM1, pve1, pve2, pve3, CK10 |
| TP-Link EAP225 Outdoor | AP (outdoor) | 10.27.27.6 | |
| Lutron Caseta Hub | Smart home | 10.27.27.7 | |
| MacBook Pro (M3 Pro) | Daily driver — company-issued | 10.27.27.11 | |
| MacBook Pro (2017) | Secondary / admin machine | — | Connected via USW Flex 2.5G Mini |
| Mac Mini #1 (macOS, A1347) | Main server / NAS brain | 10.27.27.22 | Runs arr stack, Uptime Kuma, Paperless-ngx, Pi-hole UTM VM; Pegasus DAS attached via Thunderbolt |
| Ace Magician CK10 | Jellyfin media server | 10.27.27.33 | i7-1081U, 16GB RAM |
| ChaseWorksLab NAS | TrueNAS — future build | 10.27.27.27 | Not yet built |
| Pi-hole (UTM VM) | DNS / ad blocking | 10.27.27.193 | Runs on Mac Mini #1; to be replaced by AdGuard Home on pve1 |
| pve1 (Mac Mini #2, A1347) | Proxmox Node 1 | 10.27.27.101 | Clustered |
| pve2 (Mac Mini #3, A1347) | Proxmox Node 2 | 10.27.27.102 | Clustered |
| pve3 (Mac Mini #4, A1347) | Proxmox Node 3 | 10.27.27.103 | Clustered |
| LittlePeggy (Pegasus 2 R8) | DAS / NFS storage | — | Thunderbolt 2, attached to Mac Mini #1; NFS-mounted on all Proxmox nodes |
| BigPeggy (Pegasus 3 R8) | DAS / NFS storage | — | Thunderbolt 3, daisy-chained to LittlePeggy; NFS-mounted on all Proxmox nodes |
| Tailscale | VPN / zero-trust networking | — | Not yet deployed; planned for remote access |

## Network

- **Subnet**: `10.27.27.0/24`
- **All devices**: static IPs via DHCP reservations on UniFi UX7
- **DNS**: Pi-hole at `10.27.27.193` (interim); migrating to AdGuard Home at `10.27.27.110` on pve1
- **Domain**: `chaseworkslab.com` — owned; internal resolution planned via AdGuard Home + Nginx Proxy Manager
- **VLANs**: none yet — flat network; segmentation deferred until Proxmox cluster is stable

## Services and ports

| Service | Folder | Port(s) | Host | Status | Notes |
| ------- | ------ | ------- | ---- | ------ | ----- |
| Sonarr | arr/ | `8989` | Mac Mini #1 (`10.27.27.22`) | Running | TV show automation; compose file not yet in git |
| Radarr | arr/ | `7878` | Mac Mini #1 (`10.27.27.22`) | Running | Movie automation; compose file not yet in git |
| Prowlarr | arr/ | `9696` | Mac Mini #1 (`10.27.27.22`) | Running | Indexer management; compose file not yet in git |
| qBittorrent | arr/ | `8080` ⚠️ | Mac Mini #1 (`10.27.27.22`) | Running | Torrent client; port needs verification |
| Overseerr | arr/ | `5055` | Mac Mini #1 (`10.27.27.22`) | Running | Media request UI; compose file not yet in git |
| Audiobookshelf | arr/ | `13378` | Mac Mini #1 (`10.27.27.22`) | Running | Audiobook/podcast server; compose file not yet in git |
| Jellyfin | docker/ | `8096` | Ace Magician CK10 (`10.27.27.33`) | Running | Media server; not yet Dockerized; HW transcoding unverified |
| Uptime Kuma | docker/ | `3001` | Mac Mini #1 (`10.27.27.22`) | Running | Uptime monitoring; compose file not yet in git |
| Paperless-ngx | docker/ | `8000` ⚠️ | Mac Mini #1 (`10.27.27.22`) | Running | Document management; port needs verification |
| Pi-hole | — | `53`, `80` | `10.27.27.193` (UTM VM on MM1) | Running — being replaced | Interim DNS; replaced by AdGuard Home on pve1 |
| **AdGuard Home** | lxc/pve1/ | `53`, `80`, `3000` (setup) | pve1 CT110 (`10.27.27.110`) | Ready to deploy | Native install via community script |
| **Nginx Proxy Manager** | lxc/pve1/ | `80`, `443`, `81` (admin) | pve1 CT101 (`10.27.27.111`) | Ready to deploy | Native install via community script |
| **Homepage** | lxc/pve1/ | `3000` | pve1 CT102 (`10.27.27.112`) | Ready to deploy | Native Node.js install via community script |
| Open WebUI | llm/ | TBD | TBD | Not deployed | LLM chat frontend |
| Ollama | llm/ | TBD | TBD | Not deployed | Local LLM inference backend |
| n8n | — | `5678` | pve3 (`10.27.27.133`) | Not deployed | Automation / agent orchestration |
| Grafana | monitoring/ | `3000` | pve3 (`10.27.27.132`) | Not deployed | Dashboards |
| Prometheus | monitoring/ | `9090` | pve3 (`10.27.27.131`) | Not deployed | Metrics scraping and storage |
| Node Exporter | monitoring/ | `9100` | Each Proxmox node + MM1 | Not deployed | Per-host system metrics |

## Tools

| Tool | Purpose | Installed on |
|------|---------|-------------|
| Docker + Compose | Container runtime | Mac Mini #1; planned for Proxmox LXCs |
| Ansible | Config management | Mac Mini #1 (control node) |
| UTM | macOS VM host | Mac Mini #1 (hosts Pi-hole VM) |
| fzf | Fuzzy finder | All machines (via dotfiles) |
| eza | ls replacement | All machines (via dotfiles) |
| Oh My Zsh + Powerlevel10k | Shell | macOS only (via dotfiles) |
