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
| CT ID | `101` |
| Hostname | `nginx-proxy-manager` |
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
| `audiobooks.chaseworkslab.com` | `http://10.27.27.112:13378` | Enable Websocket Support |
| `paperless.chaseworkslab.com` | Inspect live NPM host | Backend still unknown; do not recreate from this row |
| `uptime.chaseworkslab.com` | `http://10.27.27.119:3001` | pve1 CT119; enable Websocket Support |
| `npm.chaseworkslab.com` | `http://10.27.27.111:81` | — |
| `adguard.chaseworkslab.com` | `http://10.27.27.110:80` | — |
| `homepage.chaseworkslab.com` | `http://10.27.27.112:3000` | Homepage on pve1 CT112; HTTP verified 2026-09-25 |
