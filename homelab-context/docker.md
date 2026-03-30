# Docker — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Docker (via Docker Compose) is the standard deployment method for all homelab services. Every service — whether running on Mac Mini #1 (macOS) today or on a future Proxmox LXC — is containerized with a `docker-compose.yml`. This makes services reproducible, portable, and version-controlled in GitHub.

## Standard Approach
- **All services use Docker Compose** — no standalone `docker run` commands
- **Each service stack gets its own directory** with a `docker-compose.yml` and `.env.example`
- **Secrets via `.env` files** — `.env` is gitignored, `.env.example` is committed with placeholder values
- **Config directories are gitignored** — app config dirs contain API keys/tokens and must never be committed

## Current Docker Hosts

| Host | IP | Services |
|---|---|---|
| Mac Mini #1 (macOS) | 10.27.27.22 | arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr, Audiobookshelf), Uptime Kuma, Paperless-ngx |
| Ace Magician CK10 | TBD | Jellyfin |

## GitHub Repo Structure
`github.com/chaserbot/chaseworkslab-docker` holds Docker Compose stacks for general homelab services:

```
chaseworkslab-docker/
  jellyfin/
    docker-compose.yml
    .env.example
    README.md
  uptime-kuma/
    docker-compose.yml
    README.md
  paperless-ngx/
    docker-compose.yml
    .env.example
    README.md
  ...
```

**Note**: Arr-specific stacks live in `chaseworkslab-arr` (separate repo). LLM stacks live in `chaseworkslab-llm`. Monitoring (Grafana/Prometheus) lives in `chaseworkslab-monitoring`.

## .gitignore Pattern (All Docker Repos)
```gitignore
# Never commit credentials
*.env
.env*
secrets/

# Never commit app config dirs (contain API keys, tokens, DB files)
*/config/
config/

# Never commit generated databases
*.db
*.db-wal
*.db-shm
*.sqlite

# Logs
*.log
logs/
*/logs/
```

## Services on Mac Mini #1 (Needs Docker Compose Files in GitHub)

| Service | Repo | Status |
|---|---|---|
| Sonarr | chaseworkslab-arr | Not yet committed |
| Radarr | chaseworkslab-arr | Not yet committed |
| Prowlarr | chaseworkslab-arr | Not yet committed |
| qBittorrent | chaseworkslab-arr | Not yet committed |
| Overseerr | chaseworkslab-arr | Not yet committed |
| Audiobookshelf | chaseworkslab-arr or chaseworkslab-docker | Not yet committed |
| Uptime Kuma | chaseworkslab-docker | Not yet committed |
| Paperless-ngx | chaseworkslab-docker | Not yet committed |
| Jellyfin | chaseworkslab-docker | Not yet committed |

## Migration Path (Track T3)
When Proxmox cluster is ready, services move from Mac Mini #1 (macOS Docker) to Proxmox LXC containers. Because everything is in Docker Compose, migration = copy `docker-compose.yml`, update volume paths, spin up.

## Next Steps
1. SSH into Mac Mini #1, dump existing `docker-compose.yml` files for each service
2. Sanitize (remove secrets), add `.env.example`, commit to appropriate repos
3. As new services are added to Proxmox LXCs, create compose files in relevant repos first
