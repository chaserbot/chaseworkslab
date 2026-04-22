# 📡 chaseworkslab — Network Inventory

Private reference for all homelab hosts, services, and ports. Keep this updated as services move from MM1 to Proxmox. Eventually feeds into Homepage and Grafana/Prometheus scrape targets.

---

## 🖥️ Hosts

| Name | Role | OS | IP | Access |
| ---- | ---- | -- | -- | ------ |
| **MM1** — Mac Mini #1 (A1347) | NAS Brain / DAS Host | macOS | `10.27.27.22` | SSH / local |
| **MM2** — Mac Mini #2 (A1347) | Proxmox Node 1 — pve1 | Proxmox VE | `10.27.27.101` | https://10.27.27.101:8006 |
| **MM3** — Mac Mini #3 (A1347) | Proxmox Node 2 — pve2 | Proxmox VE | `10.27.27.102` | https://10.27.27.102:8006 |
| **MM4** — Mac Mini #4 (A1347) | Proxmox Node 3 — pve3 | Proxmox VE | `10.27.27.103` | https://10.27.27.103:8006 |
| **CK10** — Ace Magician CK10 | Jellyfin media server | Windows | `10.27.27.33` | — |
| **LittlePeggy** — Pegasus 2 R8 | DAS storage (TB2 → MM1) | — | N/A (Thunderbolt) | — |
| **BigPeggy** — Pegasus 3 R8 | DAS storage (TB3 → MM1) | — | N/A (Thunderbolt) | — |

---

## 🔧 Services & Ports

### Currently Running

| Service | Host | IP | Port | URL | Status |
| ------- | ---- | -- | ---- | --- | ------ |
| **Proxmox UI** | MM2 (pve1) | `10.27.27.101` | `8006` | https://10.27.27.101:8006 | ✅ Active |
| **Proxmox UI** | MM3 (pve2) | `10.27.27.102` | `8006` | https://10.27.27.102:8006 | ✅ Active |
| **Proxmox UI** | MM4 (pve3) | `10.27.27.103` | `8006` | https://10.27.27.103:8006 | ✅ Active |
| **Jellyfin** | CK10 | `10.27.27.33` | `8096` | http://10.27.27.33:8096 · https://jellyfin.chaseworkslab.com | ✅ Active |
| **AdGuard Home** | pve1 CT110 | `10.27.27.110` | `53`, `80` | http://10.27.27.110 (web UI) | ✅ Active |
| **Nginx Proxy Manager** | pve1 CT101 | `10.27.27.111` | `80`, `443`, `81` | http://10.27.27.111:81 (admin) | ✅ Active |
| **Audiobookshelf** | MM1 | `10.27.27.22` | `13378` | http://10.27.27.22:13378 | ✅ Active |
| **Radarr** | docker-arr VM | TBD | `7878` | http://docker-arr:7878 | ✅ Active |
| **Sonarr** | docker-arr VM | TBD | `8989` | http://docker-arr:8989 | ✅ Active |
| **Prowlarr** | docker-arr VM | TBD | `9696` | http://docker-arr:9696 | ✅ Active |
| **Seerr** | docker-arr VM | TBD | `5055` | http://docker-arr:5055 | ✅ Active |
| **FlareSolverr** | docker-arr VM | TBD | `8191` | http://docker-arr:8191 | ✅ Active |
| **qBittorrent** | docker-arr VM | TBD | `8080` | http://docker-arr:8080 | ✅ Active (VPN via Gluetun) |
| **Paperless-ngx** | MM1 | `10.27.27.22` | `8000` | http://10.27.27.22:8000 | ⚠️ Verify port |
| **Uptime Kuma** | MM1 | `10.27.27.22` | `3001` | http://10.27.27.22:3001 | ✅ Active |

> ⚠️ docker-arr VM IP is TBD — update this table once a static IP is assigned in Proxmox. Paperless-ngx port on MM1 still needs confirmation.

### Planned / In Progress (pve1 — front door)

| Service | CT ID | IP | Port(s) | Notes |
| ------- | ----- | -- | ------- | ----- |
| **Homepage** | 102 | `10.27.27.112` | `3000` | Not yet deployed; native Node.js install via community script; proxy via `home.chaseworkslab.com` |

### Planned (pve2 — media apps)

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
| **docker-arr VM** | `10.27.27.47` | — | Arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Seerr, FlareSolverr) — running; IP confirmed static |
| **Audiobookshelf** | `10.27.27.124` | `13378` | Moving from MM1 |

### Planned (pve3 — ops)

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
| **Prometheus** | `10.27.27.130` | `9090` | Config ready; deploy pending — LXC on pve3 |
| **pve_exporter** | `10.27.27.139` | `9221` | Running — LXC on pve3; community script |
| **Scraparr** | `10.27.27.138` | `7100` | Pending config — LXC on pve3; community script |
| **qbittorrent-exporter** | `10.27.27.137` | `8090` | Pending config — LXC on pve3; community script |
| **Uptime Kuma** | TBD | `3001` | Moving from MM1 — IP TBD |
| **Grafana** | `10.27.27.132` | `3000` | New deployment |
| **n8n** | `10.27.27.133` | `5678` | New deployment |
| **Paperless-ngx** | `10.27.27.134` | `8000` | Moving from MM1 |

---

## 💾 Storage

| Name | Type | Host | Mount (Proxmox nodes) | Proxmox Storage ID |
| ---- | ---- | ---- | --------------------- | ------------------ |
| **LittlePeggy** | Promise Pegasus 2 R8 (TB2) | MM1 — `10.27.27.22` | `/mnt/littlepeggy` | `littlepeggy` |
| **BigPeggy** | Promise Pegasus 3 R8 (TB3, capped at TB2) | MM1 — `10.27.27.22` | `/mnt/bigpeggy` | `bigpeggy` |

NFS exports from MM1:
- `/Volumes/LittlePeggy` → `10.27.27.0/24`
- `/Volumes/BigPeggy` → `10.27.27.0/24`

---

## 🌐 Network

| Device | Role | IP |
| ------ | ---- | -- |
| UniFi UX7 | Router / gateway | `10.27.27.1` |
| USW Flex 2.5G 8-port PoE | Core switch (rack) | — |
| USW Flex 2.5G Mini (4-port) | Desktop switch — MBP M3 Pro + 2017 MBP | — |
| USW Lite 8-port PoE | Server switch — MM1, pve1–3, CK10 | — |
| TP-Link EAP225 Outdoor | Outdoor access point | `10.27.27.6` |
| Pi-hole (UTM VM) | DNS interim — to be replaced by AdGuard Home | `10.27.27.193` |

Internal domain: `chaseworkslab.com`

DNS resolver: AdGuard Home at `10.27.27.110` (replaces Pi-hole at `10.27.27.193`)
Split DNS: pve1 (`10.27.27.101`) is Tailscale subnet router; `chaseworkslab.com` resolves on tailnet

Node hostnames (AdGuard DNS rewrites → direct to host):
- `pve1.chaseworkslab.com` → `10.27.27.101`
- `pve2.chaseworkslab.com` → `10.27.27.102`
- `pve3.chaseworkslab.com` → `10.27.27.103`

Service hostnames (AdGuard DNS rewrites → `10.27.27.111` → NPM → service):
- See `lxc/pve1/dns-proxy-entries.md` for complete list

---

## 📊 Monitoring Scrape Targets

Prometheus planned at `10.27.27.130:9090` (pve3 LXC). Config at `monitoring/prometheus/prometheus.yml`.

| Target | Address | Exporter | Status |
| ------ | ------- | -------- | ------ |
| Proxmox pve1 | `10.27.27.101:9100` | node_exporter | Pending |
| Proxmox pve2 | `10.27.27.102:9100` | node_exporter | Pending |
| Proxmox pve3 | `10.27.27.103:9100` | node_exporter | Pending |
| MM1 (macOS) | `10.27.27.22:9100` | node_exporter (or Telegraf) | Pending |
| CK10 (Jellyfin) | `10.27.27.33:9182` | windows_exporter | Pending |
| Proxmox API (pve1/2/3) | `10.27.27.139:9221` | pve_exporter LXC | Running |
| docker-arr VM | `10.27.27.47:9100` | node_exporter | Pending |
| Sonarr/Radarr/Prowlarr | `10.27.27.138:7100` | Scraparr | Pending credentials |
| qBittorrent | `10.27.27.137:8090` | qbittorrent-exporter | Pending credentials |
| cAdvisor (docker-arr VM) | `10.27.27.47:8085` | cadvisor | Running |

---

## 🏠 Dashboard Config (Homepage)

Config files live inside the Homepage LXC at `/opt/homepage/config/`. The service table above maps directly to the `href` and `ping` fields Homepage uses.

```yaml
# Example Homepage services.yaml snippet (not yet configured)
# - Jellyfin:
#     href: http://10.27.27.33:8096
#     ping: http://10.27.27.33:8096
#     icon: jellyfin.png
```

---

## 📋 Open TODOs

- [ ] Confirm qBittorrent web UI port on MM1
- [ ] Confirm Paperless-ngx port on MM1
- [ ] Build out remaining AdGuard DNS entries and NPM proxy hosts — see `lxc/pve1/dns-proxy-entries.md`
- [ ] Deploy Homepage LXC (CT102, `10.27.27.112`)
- [ ] Shut down Pi-hole UTM VM on MM1 (`10.27.27.193`) — router DNS already migrated
- [ ] Update network backbone with correct Unifi router and switches
