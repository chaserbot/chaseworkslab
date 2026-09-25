# Homepage LXC — pve1

Dashboard for all homelab services. Proxied through NPM at `homepage.chaseworkslab.com`.

## Deploy

Run this on pve1:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/homepage.sh)"
```

## Values to enter when prompted

| Prompt | Value |
| ------ | ----- |
| CT ID | `112` |
| Hostname | `homepage` |
| IP Address | `10.27.27.112/24` |
| Gateway | `10.27.27.1` |

Accept defaults for everything else (RAM, disk, OS).

## After deploy

- Homepage is accessible at `http://10.27.27.112:3000`
- Config files live inside the LXC at `/opt/homepage/config/`
- Edit `services.yaml`, `bookmarks.yaml`, and `settings.yaml` to configure the dashboard
- See `inventory/README.md` for the full list of service URLs to add

## Configured media services

The Media section is displayed as a three-column row and includes:

| Service | URL |
| ------- | --- |
| Jellyfin | `http://10.27.27.33:8096` |
| Audiobookshelf | `http://10.27.27.112:13378` |
| Calibre-Web | `http://10.27.27.151:8083` |

Calibre-Web is configured as a service card with an availability check in
`config/services.yaml`.
