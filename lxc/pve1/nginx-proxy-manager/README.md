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

## Proxy hosts to add

| Domain | Forward to |
| ------ | ---------- |
| `npm.chaseworkslab.com` | `http://10.27.27.111:81` |
| `adguard.chaseworkslab.com` | `http://10.27.27.110:80` |
| `homepage.chaseworkslab.com` | `http://10.27.27.112:3000` |

Add more as services are deployed. Record all mappings in `inventory/README.md`.
