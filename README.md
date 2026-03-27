# 📡 chaseworkslab — Network Inventory

Private reference for all homelab hosts, services, and ports. Keep this updated as services move from MM1 to Proxmox. Eventually feeds into Homepage/Glance/Homarr dashboard config and Grafana/Prometheus scrape targets.

---

## 🖥️ Hosts

| Name | Role | OS | IP | Access |
|---|---|---|---|---|
| **MM1** — Mac Mini #1 (A1347) | NAS Brain / DAS Host | macOS | `10.27.27.22` | SSH / local |
| **MM2** — Mac Mini #2 (A1347) | Proxmox Node 1 — pve1 | Proxmox VE | `10.27.27.101` | https://10.27.27.101:8006 |
| **MM3** — Mac Mini #3 (A1347) | Proxmox Node 2 — pve2 | Proxmox VE | `10.27.27.102` | https://10.27.27.102:8006 |
| **MM4** — Mac Mini #4 (A1347) | Proxmox Node 3 — pve3 | Proxmox VE | `10.27.27.103` | https://10.27.27.103:8006 |
| **CK10** — Ace Magician CK10 | Jellyfin media server | — | `10.27.27.33` ⚠️ | — |
| **LittlePeggy** — Pegasus 2 R8 | DAS storage (TB2 → MM1) | — | N/A (Thunderbolt) | — |
| **BigPeggy** — Pegasus 3 R8 | DAS storage (TB3 → MM1) | — | N/A (Thunderbolt) | — |

> ⚠️ CK10 is currently at `.33` but needs to be reassigned — `.33` may conflict with future Proxmox nodes. Update when resolved.

---

## 🔧 Services & Ports

### Currently Running

| Service | Host | IP | Port | URL | Status |
|---|---|---|---|---|---|
| **Proxmox UI** | MM2 (pve1) | `10.27.27.101` | `8006` | https://10.27.27.101:8006 | ✅ Active |
| **Proxmox UI** | MM3 (pve2) | `10.27.27.102` | `8006` | https://10.27.27.102:8006 | ✅ Active |
| **Proxmox UI** | MM4 (pve3) | `10.27.27.103` | `8006` | https://10.27.27.103:8006 | ✅ Active |
| **Jellyfin** | CK10 | `10.27.27.33` | `8096` | http://10.27.27.33:8096 | ✅ Active |
| **Audiobookshelf** | MM1 | `10.27.27.22` | `13378` | http://10.27.27.22:13378 | ✅ Active |
| **Radarr** | MM1 | `10.27.27.22` | `7878` | http://10.27.27.22:7878 | ✅ Active |
| **Sonarr** | MM1 | `10.27.27.22` | `8989` | http://10.27.27.22:8989 | ✅ Active |
| **Prowlarr** | MM1 | `10.27.27.22` | `9696` | http://10.27.27.22:9696 | ✅ Active |
| **Overseerr** | MM1 | `10.27.27.22` | `5055` | http://10.27.27.22:5055 | ✅ Active |
| **qBittorrent** | MM1 | `10.27.27.22` | `8080` | http://10.27.27.22:8080 | ⚠️ Verify port |
| **Paperless-ngx** | MM1 | `10.27.27.22` | `8000` | http://10.27.27.22:8000 | ⚠️ Verify port |
| **Uptime Kuma** | MM1 | `10.27.27.22` | `3001` | http://10.27.27.22:3001 | ✅ Active |

> ⚠️ qBittorrent and Paperless-ngx ports need to be confirmed — common defaults listed, verify against actual config on MM1.

### Planned (Moving to Proxmox)

| Service | Target Host | Port | Notes |
|---|---|---|---|
| **AdGuard Home** | Proxmox LXC | `53` / `80` | DNS + web UI |
| **Nginx Proxy Manager** | Proxmox LXC | `80` / `443` | Reverse proxy for all services |
| **n8n** | Proxmox LXC | `5678` | Automation |
| **Grafana** | Proxmox LXC | `3000` | Monitoring dashboards |
| **Prometheus** | Proxmox LXC | `9090` | Metrics scraper |
| **Homepage / Glance / Homarr** | Proxmox LXC | `3000` / `5000` | Dashboard — TBD which tool |
| **All MM1 services above** | Proxmox LXC/VM | — | Migrate off MM1 once cluster is stable |

---

## 💾 Storage

| Name | Type | Host | Mount (Proxmox nodes) | Proxmox Storage ID |
|---|---|---|---|---|
| **LittlePeggy** | Promise Pegasus 2 R8 (TB2) | MM1 — `10.27.27.22` | `/mnt/littlepeggy` | `littlepeggy` |
| **BigPeggy** | Promise Pegasus 3 R8 (TB3, capped at TB2) | MM1 — `10.27.27.22` | `/mnt/bigpeggy` | `bigpeggy` |

NFS exports from MM1:
- `/Volumes/LittlePeggy` → `10.27.27.0/24`
- `/Volumes/BigPeggy` → `10.27.27.0/24`

> Volume names may differ — confirm in Disk Utility on MM1 after RAID config via Promise Utility.

---

## 🌐 Network

| Device | Role | IP |
|---|---|---|
| Luxul ABR-5000 | Router / gateway | — |
| Ubiquiti USW PoE 8 Lite | Switch | — |
| Archer AX1800 | Access point | — |
| TP-Link EAP225 Outdoor | Outdoor access point | `10.27.27.6` |
| Pi-hole | DNS (offline / legacy) | `10.27.27.193` |

Internal domain: `chaseworkslab.com`

Node hostnames:
- `pve1.chaseworkslab.com` → `10.27.27.101`
- `pve2.chaseworkslab.com` → `10.27.27.102`
- `pve3.chaseworkslab.com` → `10.27.27.103`

---

## 📊 Monitoring Scrape Targets (future Prometheus config)

When Prometheus is running, these are the targets to add. Ports listed are standard defaults — confirm each before deploying.

| Target | Address | Exporter |
|---|---|---|
| Proxmox pve1 | `10.27.27.101:9100` | node_exporter |
| Proxmox pve2 | `10.27.27.102:9100` | node_exporter |
| Proxmox pve3 | `10.27.27.103:9100` | node_exporter |
| MM1 (macOS) | `10.27.27.22:9100` | node_exporter (or Telegraf) |
| CK10 (Jellyfin) | `10.27.27.33:9100` | node_exporter |
| Proxmox API | `10.27.27.101:8006` | pve_exporter |

---

## 🏠 Dashboard Config (Homepage / Glance / Homarr — TBD)

Placeholder for YAML config snippets once the dashboard tool is chosen. The service table above maps directly to the `href` and `ping` fields Homepage uses.

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
- [ ] Reassign CK10 IP off `.33` — update this doc when done
- [ ] Add MM2 and MM3 to UniFi with fixed IPs once cluster is formed
- [ ] Confirm LittlePeggy / BigPeggy volume names in Disk Utility on MM1
- [ ] Decide: Homepage vs Glance vs Homarr — update dashboard config section
- [ ] Add Nginx Proxy Manager reverse proxy URLs once running (e.g. `jellyfin.chaseworkslab.com`)
- [ ] Add AdGuard Home IP once deployed
- [ ] Update network backbone with correct Unifi router and switches
