# DNS + NPM Entries — chaseworkslab.com

Master reference for all AdGuard Home DNS rewrites and Nginx Proxy Manager proxy hosts.

**The pattern:**

1. Add a DNS rewrite in AdGuard Home: `<service>.chaseworkslab.com → 10.27.27.111`
2. Add a proxy host in NPM: `<service>.chaseworkslab.com → http://<service-ip>:<port>`

AdGuard Home admin: <http://10.27.27.110>  
NPM admin: <http://10.27.27.111:81>

---

## Tier 1 — Media and applications

| Subdomain | AdGuard rewrite | NPM forward host | NPM forward port | Status |
| ----------- | ----------------- | ------------------ | ------------------ | -------- |
| `jellyfin.chaseworkslab.com` | `10.27.27.111` | `10.27.27.33` | `8096` | ✅ Done |
| `sonarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.47` | `8989` | ✅ HTTP verified |
| `radarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.47` | `7878` | ✅ HTTP verified |
| `prowlarr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.47` | `9696` | ✅ HTTP verified |
| `seerr.chaseworkslab.com` | `10.27.27.111` | `10.27.27.47` | `5055` | ✅ HTTP verified |
| `qbit.chaseworkslab.com` | `10.27.27.111` | `10.27.27.47` | `8080` | ✅ HTTP verified |
| `audiobooks.chaseworkslab.com` | `10.27.27.111` | `10.27.27.112` | `13378` | ✅ Backend corrected; HTTP proxy verified |
| `paperless.chaseworkslab.com` | `10.27.27.111` | Verify in NPM | `8000` | ⚠️ Proxy works; backend docs stale |
| `uptime.chaseworkslab.com` | `10.27.27.111` | `10.27.27.119` | `3001` | ✅ HTTP verified |

> HTTP routes above were checked on 2026-09-25. HTTPS was not working and remains a follow-up.

---

## Tier 2 — pve1 infrastructure services

| Subdomain | AdGuard rewrite | NPM forward host | NPM forward port | Status |
| ----------- | ----------------- | ------------------ | ------------------ | -------- |
| `npm.chaseworkslab.com` | `10.27.27.111` | `10.27.27.111` | `81` | ⬜ Todo |
| `adguard.chaseworkslab.com` | `10.27.27.111` | `10.27.27.110` | `80` | ⬜ Todo |
| `homepage.chaseworkslab.com` | `10.27.27.111` | `10.27.27.112` | `3000` | ✅ HTTP verified — Homepage is CT112 |

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
- Seerr uses its own authentication; no NPM access list is required unless an additional gate is desired.
- When services migrate from MM1 to Proxmox LXCs (pve2/pve3), update only the NPM forward host/port. The subdomain and AdGuard entry stay the same — that's the whole point of the reverse proxy.

---

## Current migration state

The arr stack has moved to the docker-arr VM at `10.27.27.47`. Seerr replaced Overseerr. Audiobookshelf is served from `10.27.27.112:13378`.
