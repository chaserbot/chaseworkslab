# arr stack

Arr stack running on the `docker-arr` Proxmox VM via Docker Compose.

## Services

| Service | Port | Notes |
| ------- | ---- | ----- |
| Prowlarr | `9696` | Indexer management |
| Radarr | `7878` | Movie automation |
| Sonarr | `8989` | TV show automation |
| Exportarr Radarr | `9707` | Prometheus metrics for Radarr |
| Exportarr Sonarr | `9708` | Prometheus metrics for Sonarr |
| Exportarr Prowlarr | `9709` | Prometheus metrics for Prowlarr |
| qBittorrent | `8080` | Torrent client; routes through Gluetun VPN (kill switch) |
| Gluetun | — | ProtonVPN OpenVPN gateway; qBit uses `network_mode: service:gluetun` |
| FlareSolverr | `8191` | Cloudflare bypass for Prowlarr indexers |
| Seerr | `5055` | Media request UI; replaces Overseerr |

## VPN

qBittorrent traffic is routed through Gluetun (ProtonVPN). If Gluetun restarts or the VPN connection drops, qBittorrent loses network access (kill switch behavior) and may need a manual restart.

## Storage

All volumes mount from BigPeggy via NFS:

- `/mnt/bigpeggy/Downloads` — torrent download staging
- `/mnt/bigpeggy/MEDIA/Movies` — Radarr library
- `/mnt/bigpeggy/MEDIA/TV` — Sonarr library

## Setup

1. Copy `.env.example` to `.env` and fill in your ProtonVPN credentials, APPDATA path, and Arr API keys.
2. `docker compose up -d`

App config is persisted to `$APPDATA` (default `/opt/arr-stack/config`). That directory is gitignored — do not commit it.
