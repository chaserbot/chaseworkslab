# Nginx Proxy Manager LXC — pve1

Reverse proxy. Routes `*.chaseworkslab.com` subdomains to backend services.

## Deploy

Run this on pve1:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/nginxproxymanager.sh)"
```

## Values to enter when prompted

| Prompt | Value |
| ------ | ----- |
| CT ID | `111` |
| Hostname | `nginxproxymanager` |
| IP Address | `10.27.27.111/24` |
| Gateway | `10.27.27.1` |

Accept defaults for everything else (RAM, disk, OS).

## After deploy

1. Open the admin UI at `http://10.27.27.111:81`
2. Log in with default credentials: `admin@example.com` / `changeme` — **change these immediately**
3. Add a proxy host for each service pointing to its backend IP:port

For the full list of proxy hosts to configure, see **`../dns-proxy-entries.md`**.

## Quick reference — proxy hosts

| Domain | Forward to | Notes |
| ------ | ---------- | ----- |
| `jellyfin.chaseworkslab.com` | `http://10.27.27.33:8096` | Enable Websocket Support |
| `sonarr.chaseworkslab.com` | `http://10.27.27.47:8989` | Enable Websocket Support |
| `radarr.chaseworkslab.com` | `http://10.27.27.47:7878` | Enable Websocket Support |
| `prowlarr.chaseworkslab.com` | `http://10.27.27.47:9696` | Enable Websocket Support |
| `seerr.chaseworkslab.com` | `http://10.27.27.47:5055` | Enable Websocket Support |
| `qbit.chaseworkslab.com` | `http://10.27.27.47:8080` | qBittorrent through Gluetun |
| `audiobooks.chaseworkslab.com` | `http://10.27.27.121:13378` | pve2 CT211; enable Websocket Support |
| `homepage.chaseworkslab.com` | `http://10.27.27.112:3000` | Homepage on pve1 CT112; HTTP verified 2026-09-25 |

Calibre-Web is also live: `ebooks.chaseworkslab.com` forwards to pve3 CT101 at `10.27.27.151:8083`.

## Audit notes

- `uptime.chaseworkslab.com`, `paperless.chaseworkslab.com`, `npm.chaseworkslab.com`, and `adguard.chaseworkslab.com` resolve to NPM but do not currently have proxy-host records; they show NPM's default site.
- Paperless is not deployed.
- `mini-pc.chaseworkslab.com` is an enabled but ineffective entry forwarding HTTP to `10.27.27.33:22`. Internal DNS does not direct that name to NPM. Disable it or replace it with the intended protocol/service.
