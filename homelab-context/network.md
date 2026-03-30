# Network & Infrastructure — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Home network running on a Luxul ABR-5000 router with a Luxul switch and two access points. Subnet is `10.27.27.0/24`. All homelab devices use static IPs (DHCP reservations). Pi-hole handles local DNS, currently running as a UTM VM on Mac Mini #1.

## Network Map

| Device | Role | IP |
|---|---|---|
| Luxul ABR-5000 | Router / gateway | 10.27.27.1 |
| Luxul switch | Layer 2 switching | 10.27.27.3 |
| Archer AX1800 | AP (indoor) | 10.27.27.5 |
| TP-Link EAP225 Outdoor | AP (outdoor) | 10.27.27.6 |
| Lutron Caseta Hub | Smart home | 10.27.27.7 |
| MacBook Pro (M3) | Daily driver — company-issued | 10.27.27.11 |
| Mac Mini #1 (macOS) | Main server / NAS brain | 10.27.27.22 |
| ChaseWorksLab NAS | TrueNAS — future build | 10.27.27.27 |
| Pi-hole | DNS / ad blocking | 10.27.27.193 |
| pve1 | Proxmox Node 1 | 10.27.27.31 |
| pve2 | Proxmox Node 2 | 10.27.27.32 |
| pve3 | Proxmox Node 3 | 10.27.27.33 |

## Domain
`chaseworkslab.com` — owned, DNS not configured yet.
Plan: use for local DNS resolution (`.chaseworkslab.com` for internal services) and eventually external access via Tailscale or reverse proxy.

## Pi-hole
- **Current**: Running as UTM VM on Mac Mini #1 (`10.27.27.193`)
- **Planned**: Migrate to LXC container on Proxmox cluster (Track T2)
- Handles DNS for all local devices; router points all clients at `10.27.27.193` for DNS

## Current Limitations / Pending Work
- No VLANs yet — all devices on flat `10.27.27.0/24`
- `chaseworkslab.com` DNS not configured (no split-horizon, no internal `.local` override yet)
- Tailscale not yet deployed (planned for remote access)
- Pi-hole is on a UTM VM (Mac Mini #1) — fragile, needs to move to Proxmox LXC

## Related GitHub Repos
- `github.com/chaserbot/chaseworkslab-proxmox` — includes network config notes
- DNS/networking work will land in `chaseworkslab-lxc` once Pi-hole moves to LXC

## Next Steps (Track T2)
1. Migrate Pi-hole from UTM VM → Proxmox LXC
2. Configure `chaseworkslab.com` for internal DNS (A records for each service)
3. Deploy Tailscale (either as standalone or via Proxmox LXC) for remote access
4. Consider VLAN segmentation (IoT vs. servers vs. personal devices) — future
