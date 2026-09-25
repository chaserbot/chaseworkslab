# ChaseWorksLab emergency reference

Print or save an offline copy. Last verified: 2026-09-25.

## If the lab is down

1. **Do not delete, reinstall, or reset anything yet.** Take a photo or copy the error.
2. Check power, Ethernet links, the UniFi router, and the server switch.
3. Open services by **direct IP** using the tables below. If direct IP works but the friendly name does not, check AdGuard and NPM.
4. Check MM1 before storage-dependent services. MM1 provides both Pegasus NFS shares.
5. Check Proxmox, then its guests, then individual applications.
6. Use the password manager for credentials. No passwords belong in this sheet.

## Core network and hosts

| Device | Address | Purpose |
| ------ | ------- | ------- |
| UniFi UX7 | `10.27.27.1` | Router, gateway, DHCP |
| MM1 | `10.27.27.22` | macOS NFS host; LittlePeggy and BigPeggy |
| CK10 | `10.27.27.33` | Windows Jellyfin host |
| docker-arr | `10.27.27.47` | Proxmox VM210; media automation stack |
| pve1 | `https://10.27.27.101:8006` | Proxmox node 1; front door and Tailscale subnet router |
| pve2 | `https://10.27.27.102:8006` | Proxmox node 2; docker-arr host |
| pve3 | `https://10.27.27.103:8006` | Proxmox node 3 |

LAN: `10.27.27.0/24`  
Gateway: `10.27.27.1`  
Active DNS: `10.27.27.110`  
Internal domain: `chaseworkslab.com`

## Infrastructure services

| Service | Direct address | Location |
| ------- | -------------- | -------- |
| AdGuard Home | `http://10.27.27.110` | pve1 CT110; DNS port `53` |
| NPM admin | `http://10.27.27.111:81` | pve1 CT101 |
| Homepage | `http://10.27.27.112:3000` | pve1 CT112 |
| Audiobookshelf | `http://10.27.27.112:13378` | `.112`; `audiobooks.chaseworkslab.com` |
| Uptime Kuma | `http://10.27.27.119:3001` | pve1 CT119 |
| Glances | `http://10.27.27.101:61208` | Repeat with `.102` and `.103` |

## Application services

| Service | Direct address |
| ------- | -------------- |
| Jellyfin | `http://10.27.27.33:8096` |
| Seerr | `http://10.27.27.47:5055` |
| Sonarr | `http://10.27.27.47:8989` |
| Radarr | `http://10.27.27.47:7878` |
| Prowlarr | `http://10.27.27.47:9696` |
| qBittorrent | `http://10.27.27.47:8080` |
| FlareSolverr | `http://10.27.27.47:8191` |
| Paperless | `http://paperless.chaseworkslab.com` — backend currently unknown; inspect NPM |

## Storage dependency

| Storage | NFS export from MM1 | Proxmox mount | Storage ID |
| ------- | ------------------- | ------------- | ---------- |
| LittlePeggy | `10.27.27.22:/Volumes/LittlePeggy` | `/mnt/littlepeggy` | `littlepeggy` |
| BigPeggy | `10.27.27.22:/Volumes/BigPeggy` | `/mnt/bigpeggy` | `bigpeggy` |

If MM1 or its Thunderbolt connection is down, these NFS shares are down too. Avoid starting storage-dependent guests until the mounts are healthy.

## Quick diagnosis

| What works? | Most likely problem |
| ----------- | ------------------- |
| Direct IP works; friendly name does not | AdGuard DNS rewrite or client DNS |
| HTTP direct IP works; proxy name does not | NPM proxy host or DNS rewrite |
| HTTP works; HTTPS does not | NPM certificate or SSL settings |
| Proxmox works; application IP does not | Guest, container, VM, or app problem |
| Apps start but media/storage is missing | MM1, Thunderbolt DAS, NFS export, or Proxmox mount |
| Nothing on the LAN works | Router, switch, power, cabling, or addressing problem |

## Recovery order

1. Router and switches
2. MM1 and both Pegasus arrays
3. Proxmox nodes
4. AdGuard Home CT110
5. NPM CT101 and pve1 Tailscale routing
6. Application VMs/containers and Jellyfin
7. Homepage and Uptime Kuma

## Documentation and credentials

- GitHub: `https://github.com/chaserbot/chaseworkslab`
- Local repo: `/Users/ccook/Documents/Projects/chaseworkslab`
- Full inventory: `inventory/README.md`
- Current status: `CURRENT_STATE.md`
- Recovery guide: Obsidian → `09-Homelab-Infra/04-Recovery-Runbook`
- Credentials: use the password manager and SSH agent; never add secrets to this file.

## After recovery

- Confirm the service's main function, not only that its web page loads.
- Confirm Uptime Kuma is green and notifications work.
- Update `inventory/README.md`, `CURRENT_STATE.md`, and the matching Obsidian notes.
- Commit and push the documentation changes.
