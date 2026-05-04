# DNS + NPM Entries — chaseworkslab.com

Master reference for all AdGuard Home DNS rewrites and Nginx Proxy Manager proxy hosts.

**The pattern:**

1. Add a DNS rewrite in AdGuard Home: `<service>.chaseworkslab.com → 10.27.27.111`
2. Add a proxy host in NPM: `<service>.chaseworkslab.com → http://<service-ip>:<port>`

AdGuard Home admin: <http://10.27.27.110>  
NPM admin: <http://10.27.27.111:81>

---

## Tier 1 — Media (currently running on MM1 / CK10)

| Subdomain | AdGuard rewrite | NPM forward host | NPM forward port | Status |
| ----------- | ----------------- | ------------------ | ------------------ | -------- |
| `jellyfin.chaseworkslab.com` | `10.27.27.111` | `10.27.27.33` | `8096` | ✅ Done |
| `sonarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `8989` | ⬜ Todo |
| `radarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `7878` | ⬜ Todo |
| `prowlarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `9696` | ⬜ Todo |
| `overseerr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `5055` | ⬜ Todo |
| `qbit.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `8080` ⚠️ verify | ⬜ Todo |
| `abs.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `13378` | ⬜ Todo |
| `paperless.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `8000` ⚠️ verify | ⬜ Todo |
| `uptime.chaseworkslab.com` | `10.27.27.111` | `10.27.27.22` | `3001` | ⬜ Todo |

> ⚠️ qBittorrent and Paperless-ngx ports are common defaults — confirm against actual config on MM1 before adding.

---

## Tier 2 — pve1 infrastructure services

| Subdomain | AdGuard rewrite | NPM forward host | NPM forward port | Status |
| ----------- | ----------------- | ------------------ | ------------------ | -------- |
| `npm.chaseworkslab.com` | `10.27.27.111` | `10.27.27.111` | `81` | ⬜ Todo |
| `adguard.chaseworkslab.com` | `10.27.27.111` | `10.27.27.110` | `80` | ⬜ Todo |
| `home.chaseworkslab.com` | `10.27.27.111` | `10.27.27.112` | `3000` | ⬜ Todo (Homepage not yet deployed) |

---

## Tier 3 — Proxmox nodes (direct DNS, no NPM)

These resolve directly to the Proxmox node IPs — they bypass NPM entirely. Proxmox runs HTTPS with a self-signed cert; routing it through NPM adds friction without benefit.

|Subdomain|AdGuard rewrite|Notes|
|-----------|-----------------|-------|
|`pve1.chaseworkslab.com`|`10.27.27.101`|Direct to node — no NPM entry|
|`pve2.chaseworkslab.com`|`10.27.27.102`|Direct to node — no NPM entry|
|`pve3.chaseworkslab.com`|`10.27.27.103`|Direct to node — no NPM entry|

Access Proxmox at: `https://pve1.chaseworkslab.com:8006` etc.

---

## Tier 4 — Not yet deployed (add DNS + NPM entries when live)

| Subdomain | Future forward host | Port | Notes |
| ----------- | --------------------- | ------ | ------- |
| `n8n.chaseworkslab.com` | `10.27.27.133` | `5678` | pve3 — not yet deployed |

---

## Notes

- All NPM proxy hosts: enable **Websocket Support** — required for Jellyfin, Uptime Kuma, and most web UIs.
- For qBittorrent: set `X-Frame-Options` header in NPM Advanced tab if the UI refuses to load in iframes.
- For Overseerr: it uses its own auth — no NPM access list needed.
- When services migrate from MM1 to Proxmox LXCs (pve2/pve3), update only the NPM forward host/port. The subdomain and AdGuard entry stay the same — that's the whole point of the reverse proxy.

---

## Migration note (future pve2 IPs)

When the arr stack moves from MM1 to pve2, update NPM to point to the new IPs:

| Service | Current (MM1) | Future (pve2) |
| -------- | -------------- | -------------- |
| Sonarr | `10.27.27.22:8989` | `10.27.27.120:8989` |
| Radarr | `10.27.27.22:7878` | `10.27.27.121:7878` |
| Prowlarr | `10.27.27.22:9696` | `10.27.27.122:9696` |
| Overseerr | `10.27.27.22:5055` | `10.27.27.123:5055` |
| Audiobookshelf | `10.27.27.22:13378` | `10.27.27.124:13378` |
