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
| **Radarr** | MM1 | `10.27.27.22` | `7878` | http://10.27.27.22:7878 | ✅ Active |
| **Sonarr** | MM1 | `10.27.27.22` | `8989` | http://10.27.27.22:8989 | ✅ Active |
| **Prowlarr** | MM1 | `10.27.27.22` | `9696` | http://10.27.27.22:9696 | ✅ Active |
| **Overseerr** | MM1 | `10.27.27.22` | `5055` | http://10.27.27.22:5055 | ✅ Active |
| **qBittorrent** | MM1 | `10.27.27.22` | `8080` | http://10.27.27.22:8080 | ⚠️ Verify port |
| **Paperless-ngx** | MM1 | `10.27.27.22` | `8000` | http://10.27.27.22:8000 | ⚠️ Verify port |
| **Uptime Kuma** | MM1 | `10.27.27.22` | `3001` | http://10.27.27.22:3001 | ✅ Active |

> ⚠️ qBittorrent and Paperless-ngx ports need to be confirmed — common defaults listed, verify against actual config on MM1.

### Planned / In Progress (pve1 — front door)

| Service | CT ID | IP | Port(s) | Notes |
| ------- | ----- | -- | ------- | ----- |
| **Homepage** | 102 | `10.27.27.112` | `3000` | Not yet deployed; native Node.js install via community script; proxy via `home.chaseworkslab.com` |

### Planned (pve2 — media apps)

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
| **Sonarr** | `10.27.27.120` | `8989` | Moving from MM1 |
| **Radarr** | `10.27.27.121` | `7878` | Moving from MM1 |
| **Prowlarr** | `10.27.27.122` | `9696` | Moving from MM1 |
| **Overseerr** | `10.27.27.123` | `5055` | Moving from MM1 |
| **Audiobookshelf** | `10.27.27.124` | `13378` | Moving from MM1 |

### Planned (pve3 — ops)

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
| **Uptime Kuma** | `10.27.27.130` | `3001` | Moving from MM1 |
| **Prometheus** | `10.27.27.131` | `9090` | New deployment |
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

## 📊 Monitoring Scrape Targets (future Prometheus config)

When Prometheus is running, these are the targets to add. Ports listed are standard defaults — confirm each before deploying.

| Target | Address | Exporter |
| ------ | ------- | -------- |
| Proxmox pve1 | `10.27.27.101:9100` | node_exporter |
| Proxmox pve2 | `10.27.27.102:9100` | node_exporter |
| Proxmox pve3 | `10.27.27.103:9100` | node_exporter |
| MM1 (macOS) | `10.27.27.22:9100` | node_exporter (or Telegraf) |
| CK10 (Jellyfin) | `10.27.27.33:9100` | node_exporter |
| Proxmox API | `10.27.27.101:8006` | pve_exporter |

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
