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
| Mac Mini #1 (macOS, A1347) | Main server / NAS brain | 10.27.27.22 | Runs Audiobookshelf, Uptime Kuma, Paperless-ngx, Pi-hole UTM VM; Pegasus DAS attached via Thunderbolt; NFS server for BigPeggy/LittlePeggy |
| Ace Magician CK10 | Jellyfin media server | 10.27.27.33 | i7-1081U, 16GB RAM |
| ChaseWorksLab NAS | TrueNAS — future build | 10.27.27.27 | Not yet built |
| Pi-hole (UTM VM) | DNS / ad blocking | 10.27.27.193 | Runs on Mac Mini #1; to be replaced by AdGuard Home on pve1 |
| pve1 (Mac Mini #2, A1347) | Proxmox Node 1 | 10.27.27.101 | Clustered |
| pve2 (Mac Mini #3, A1347) | Proxmox Node 2 | 10.27.27.102 | Clustered |
| pve3 (Mac Mini #4, A1347) | Proxmox Node 3 | 10.27.27.103 | Clustered |
| LittlePeggy (Pegasus 2 R8) | DAS / NFS storage | — | Thunderbolt 2, attached to Mac Mini #1; NFS-mounted on all Proxmox nodes |
| BigPeggy (Pegasus 3 R8) | DAS / NFS storage | — | Thunderbolt 3, daisy-chained to LittlePeggy; NFS-mounted on all Proxmox nodes |
| Tailscale | VPN / subnet router | — | Running on pve1; subnet router for `10.27.27.0/24`; split DNS for `chaseworkslab.com` via tailnet |

## Network

- **Subnet**: `10.27.27.0/24`
- **All devices**: static IPs via DHCP reservations on UniFi UX7
- **DNS**: AdGuard Home at `10.27.27.110` (pve1 CT110) — active; Pi-hole UTM VM (`10.27.27.193`) being phased out
- **Split DNS (Tailscale)**: pve1 acts as Tailscale subnet router for `10.27.27.0/24`; `chaseworkslab.com` resolves correctly on tailnet
- **Domain**: `chaseworkslab.com` — internal DNS rewrites active via AdGuard Home; `*.chaseworkslab.com` → `10.27.27.111` (NPM)
- **VLANs**: none yet — flat network; segmentation deferred until Proxmox cluster is stable

## Services and ports

| Service | Folder | Port(s) | Host | Status | Notes |
| ------- | ------ | ------- | ---- | ------ | ----- |
| Sonarr | arr/ | `8989` | docker-arr VM | Running | TV show automation |
| Radarr | arr/ | `7878` | docker-arr VM | Running | Movie automation |
| Prowlarr | arr/ | `9696` | docker-arr VM | Running | Indexer management |
| qBittorrent | arr/ | `8080` | docker-arr VM | Running | Torrent client; routes through Gluetun VPN kill switch |
| Gluetun | arr/ | `6881`, `6881/udp` | docker-arr VM | Running | ProtonVPN OpenVPN gateway for qBittorrent |
| FlareSolverr | arr/ | `8191` | docker-arr VM | Running | Cloudflare bypass for Prowlarr |
| Seerr | arr/ | `5055` | docker-arr VM | Running | Media request UI; replaces Overseerr |
| Audiobookshelf | arr/ | `13378` | Mac Mini #1 (`10.27.27.22`) | Running | Audiobook/podcast server; compose file not yet in git |
| Jellyfin | docker/ | `8096` | Ace Magician CK10 (`10.27.27.33`) | Running | Media server; not yet Dockerized; HW transcoding unverified |
| Uptime Kuma | docker/ | `3001` | Mac Mini #1 (`10.27.27.22`) | Running | Uptime monitoring; compose file not yet in git |
| Paperless-ngx | docker/ | `8000` ⚠️ | Mac Mini #1 (`10.27.27.22`) | Running | Document management; port needs verification |
| Pi-hole | — | `53`, `80` | `10.27.27.193` (UTM VM on MM1) | Decommissioning | Router DNS updated to AdGuard Home; UTM VM can be shut down |
| **AdGuard Home** | lxc/pve1/ | `53`, `80` | pve1 CT110 (`10.27.27.110`) | Running | DNS ad-blocking + rewrites; individual entry per service → `10.27.27.111` |
| **Nginx Proxy Manager** | lxc/pve1/ | `80`, `443`, `81` (admin) | pve1 CT101 (`10.27.27.111`) | Running | Reverse proxy for `*.chaseworkslab.com`; Jellyfin live, more entries pending |
| **Homepage** | lxc/pve1/ | `3000` | pve1 CT102 (`10.27.27.112`) | Not deployed | Native Node.js install via community script |
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
