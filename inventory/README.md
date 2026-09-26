# 📡 chaseworkslab — Network Inventory

Private reference for all homelab hosts, services, and ports. Keep this updated as services move from MM1 to Proxmox. Eventually feeds into Homepage and Grafana/Prometheus scrape targets.

For the private, editable address sheet—including the masked password-display helper—use the [Cook Home IP Address Google Sheet](https://docs.google.com/spreadsheets/d/1wcD-f8_4jbpw__dxRGKGQTz4TdIqOjEwyOadDSXw24c/edit?usp=sharing). Access is restricted to Chase's Google account. Keep credentials out of this repository; this file remains the sanitized infrastructure source of truth.

## Quick reference

| What | Address | Notes |
| ---- | ------- | ----- |
| Router | `10.27.27.1` | UniFi UX7 |
| MM1 storage/NFS host | `10.27.27.22` | LittlePeggy and BigPeggy attached |
| Jellyfin | `10.27.27.33:8096` | CK10 |
| docker-arr VM | `10.27.27.47` | Seerr, Sonarr, Radarr, Prowlarr, qBittorrent, FlareSolverr |
| pve1 / pve2 / pve3 | `10.27.27.101` / `.102` / `.103` | Proxmox UI on port `8006` |
| AdGuard Home | `10.27.27.110` | pve1 CT110; DNS port `53`, UI port `80` |
| Nginx Proxy Manager | `10.27.27.111` | pve1 CT101; admin port `81` |
| Homepage | `10.27.27.112:3000` | pve1 CT112 |
| Audiobookshelf | `10.27.27.112:13378` | `audiobooks.chaseworkslab.com` |
| Uptime Kuma | `10.27.27.119:3001` | pve1 CT119 |
| Paperless-ngx | Unknown | Proxy responds; inspect NPM for the current backend |

Use this file for current addresses. `DECISIONS.md` is historical and can contain previous placements.

---

## 🖥️ Hosts

| Name | Role | OS | IP | Access |
| ---- | ---- | -- | -- | ------ |
| **MM1** — Mac Mini #1 (A1347) | NAS Brain / DAS Host | macOS | `10.27.27.22` | SSH / local |
| **MM2** — Mac Mini #2 (A1347) | Proxmox Node 1 — pve1 | Proxmox VE | `10.27.27.101` | <https://10.27.27.101:8006> |
| **MM3** — Mac Mini #3 (A1347) | Proxmox Node 2 — pve2 | Proxmox VE | `10.27.27.102` | <https://10.27.27.102:8006> |
| **MM4** — Mac Mini #4 (A1347) | Proxmox Node 3 — pve3 | Proxmox VE | `10.27.27.103` | <https://10.27.27.103:8006> |
| **CK10** — Ace Magician CK10 | Jellyfin media server | Windows | `10.27.27.33` | — |
| **LittlePeggy** — Pegasus 2 R8 | DAS storage (TB2 → MM1) | — | N/A (Thunderbolt) | — |
| **BigPeggy** — Pegasus 3 R8 | DAS storage (TB3 → MM1) | — | N/A (Thunderbolt) | — |

---

## 🔧 Services & Ports

### Currently Running

| Service | Host | IP | Port | URL | Status |
| ------- | ---- | -- | ---- | --- | ------ |
| **Proxmox UI** | MM2 (pve1) | `10.27.27.101` | `8006` | <https://10.27.27.101:8006> | ✅ Active |
| **Proxmox UI** | MM3 (pve2) | `10.27.27.102` | `8006` | <https://10.27.27.102:8006> | ✅ Active |
| **Proxmox UI** | MM4 (pve3) | `10.27.27.103` | `8006` | <https://10.27.27.103:8006> | ✅ Active |
| **Jellyfin** | CK10 | `10.27.27.33` | `8096` | <http://10.27.27.33:8096> · <https://jellyfin.chaseworkslab.com> | ✅ Active |
| **AdGuard Home** | pve1 CT110 | `10.27.27.110` | `53`, `80` | <http://10.27.27.110> (web UI) | ✅ Active |
| **Nginx Proxy Manager** | pve1 CT101 | `10.27.27.111` | `80`, `443`, `81` | <http://10.27.27.111:81> (admin) | ✅ Active |
| **Audiobookshelf** | `10.27.27.112` | `10.27.27.112` | `13378` | <http://10.27.27.112:13378> · <http://audiobooks.chaseworkslab.com> | ✅ Active |
| **Homepage** | pve1 CT112 | `10.27.27.112` | `3000` | <http://10.27.27.112:3000> | ✅ Active |
| **Radarr** | docker-arr VM | `10.27.27.47` | `7878` | <http://10.27.27.47:7878> | ✅ Active |
| **Sonarr** | docker-arr VM | `10.27.27.47` | `8989` | <http://10.27.27.47:8989> | ✅ Active |
| **Prowlarr** | docker-arr VM | `10.27.27.47` | `9696` | <http://10.27.27.47:9696> | ✅ Active |
| **Seerr** | docker-arr VM | `10.27.27.47` | `5055` | <http://10.27.27.47:5055> | ✅ Active |
| **FlareSolverr** | docker-arr VM | `10.27.27.47` | `8191` | <http://10.27.27.47:8191> | ✅ Active |
| **qBittorrent** | docker-arr VM | `10.27.27.47` | `8080` | <http://10.27.27.47:8080> | ✅ Active (VPN via Gluetun) |
| **Paperless-ngx** | Unknown; inspect NPM | — | `8000` (unconfirmed) | <http://paperless.chaseworkslab.com> | ⚠️ Proxy responds; former MM1 endpoint failed |
| **Uptime Kuma** | pve1 CT119 | `10.27.27.119` | `3001` | <http://10.27.27.119:3001> | ✅ Active |

> ⚠️ Paperless still needs backend verification: its documented MM1 endpoint did not respond on 2026-09-25, while its HTTP proxy name did. Audiobookshelf was corrected to `10.27.27.112:13378` after the audit.

### pve1 front door

| Service | CT ID | IP | Port(s) | Notes |
| ------- | ----- | -- | ------- | ----- |
| **Homepage** | 112 | `10.27.27.112` | `3000` | Running; native Node.js install via community script; HTTP proxy via `homepage.chaseworkslab.com` |

### Media application placement

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
| **docker-arr VM** | `10.27.27.47` | — | Arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Seerr, FlareSolverr) — running; IP confirmed static |
| **Audiobookshelf** | `10.27.27.112` | `13378` | Running; no pve2 migration currently required |

### Planned services

| Service | Target IP | Port | Notes |
| ------- | --------- | ---- | ----- |
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
| Pi-hole (UTM VM) | Legacy DNS — pending safe shutdown | `10.27.27.193` |

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

## 🏠 Dashboard Config (Homepage)

Config files live inside the Homepage LXC at `/opt/homepage/config/`. The service table above maps directly to the `href` and `ping` fields Homepage uses.

```yaml
# Example Homepage services.yaml snippet
# - Jellyfin:
#     href: http://10.27.27.33:8096
#     ping: http://10.27.27.33:8096
#     icon: jellyfin.png
```

---

## 📋 Open TODOs

- [x] Confirm qBittorrent web UI at `10.27.27.47:8080`
- [ ] Identify and document the actual Paperless-ngx backend
- [ ] Add HTTPS certificates/hosts for internal NPM routes — see `lxc/pve1/dns-proxy-entries.md`
- [x] Deploy Homepage LXC (CT112, `10.27.27.112`)
- [ ] Shut down Pi-hole UTM VM on MM1 (`10.27.27.193`) — router DNS already migrated
- [ ] Update network backbone with correct Unifi router and switches
