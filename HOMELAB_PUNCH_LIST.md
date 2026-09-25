# Homelab punch list

Last reviewed: 2026-09-25

This list is ordered by importance. You do not need to finish it all at once.

Time estimates are approximate **hands-on time** for someone newer to homelabbing. Backups, file copies, updates, and scans may continue running after the hands-on work is finished.

## Suggested schedule

| Session | Goal | Estimated time |
| ------- | ---- | -------------- |
| 1 | Find Paperless and fix internal HTTPS | 1–3 hours |
| 2 | Make a backup plan and back up the most important services | 2–4 hours, plus copy time |
| 3 | Improve Uptime Kuma monitoring and notifications | 2–3 hours |
| 4 | Add a health-check script and document updates | 2–4 hours |
| Later | DNS redundancy, UPS planning, account cleanup, and VLANs | Several smaller sessions |

## 1. Make sure the lab can be recovered

This is the highest priority because a working service can still be one disk failure away from being lost.

- [ ] **Write down what must be backed up.** Include Proxmox guests, NPM, AdGuard Home, Homepage and its `.env`, the arr applications, Uptime Kuma, Audiobookshelf, Paperless, and Jellyfin metadata. **Estimate: 45–90 minutes.**
- [ ] **Choose a backup location that is not MM1 or either Pegasus drive.** If MM1 fails, its storage and any backups stored there could disappear together. An external drive, another computer, or cloud storage can be the second copy. **Estimate: 30–60 minutes to choose and configure; file copying may take hours.**
- [ ] **Create the first backups and confirm the files are not empty.** Start with NPM, AdGuard, Proxmox guest backups, and application databases/config folders. **Estimate: 2–4 hours, plus transfer time.**
- [ ] **Practice restoring one noncritical service or test copy.** Write down every step, the passwords or tokens needed, and how long it took. **Estimate: 1–3 hours.**

## 2. Fix HTTPS for internal service names

The service names work over HTTP, but HTTPS failed during the audit. Fixing this removes browser warnings and protects login traffic on the LAN.

- [ ] **Check NPM's SSL settings and certificate for one service first.** Homepage is a good test target. **Estimate: 30–60 minutes.**
- [ ] **Apply the working certificate setup to the other service names.** Test Homepage, Jellyfin, Sonarr, Radarr, Prowlarr, Seerr, qBittorrent, Audiobookshelf, Paperless, and Uptime Kuma. **Estimate: 45–90 minutes.**
- [ ] **Turn on Force SSL only after each HTTPS address works.** Leave HSTS off until everything is stable; browsers remember HSTS and it can make troubleshooting harder. **Estimate: 15–30 minutes.**

## 3. Finish locating and documenting services

- [x] **Audiobookshelf:** corrected to `10.27.27.112:13378` and `audiobooks.chaseworkslab.com`.
- [ ] **Paperless:** open its proxy host in NPM and record the Forward Hostname/IP and Forward Port. The friendly address works, but the actual backend is still unknown. **Estimate: 10–20 minutes.**
- [x] **Uptime Kuma:** confirmed on pve1 CT119 at `10.27.27.119:3001`.
- [x] **Arr stack:** confirmed on docker-arr VM210 at `10.27.27.47`; Seerr replaced Overseerr.
- [x] **Current documentation:** reconciled around `inventory/README.md` as the main IP and port reference.

## 4. Improve monitoring and alerts

Uptime checks should tell you about problems before you discover them manually.

- [ ] **Add basic Uptime Kuma monitors.** Monitor the three Proxmox interfaces, AdGuard DNS, NPM, Homepage, Jellyfin, Audiobookshelf, the arr applications, Paperless, and MM1. **Estimate: 60–90 minutes.**
- [ ] **Add one notification method and test it.** Email, Discord, Slack, or another service is enough. Temporarily pause a safe test service or use a deliberately invalid test monitor. **Estimate: 30–60 minutes.**
- [ ] **Add storage and backup warnings.** Watch disk space, NFS mounts, backup age, and Pegasus drive health. These checks are more important for preventing data loss than simple website checks. **Estimate: 2–4 hours.**
- [ ] **Add certificate-expiration alerts.** Warn at least 14–30 days before expiry. **Estimate: 20–40 minutes.**
- [ ] **Limit Glances access.** Confirm port `61208` is reachable only from the trusted LAN/Tailscale network, not the public internet. **Estimate: 30–60 minutes.**

## 5. Reduce important single points of failure

A single point of failure is one device whose failure takes down an entire function.

- [ ] **Decide whether to run a second DNS server.** Today, AdGuard Home on pve1 is the only active resolver. A small second instance on another node would keep DNS working during maintenance. **Estimate: 1–3 hours.**
- [ ] **Write down emergency addresses.** If DNS, NPM, or Tailscale routing fails, keep the direct IP list in `inventory/README.md` available offline. **Estimate: 15–30 minutes.**
- [ ] **Plan power protection.** List what a UPS must power and how MM1, the Pegasus drives, networking equipment, and Proxmox nodes should shut down during a long outage. **Estimate: 1–2 hours to plan; hardware setup depends on purchase and delivery.**

## 6. Make services easier to rebuild

The goal is to rebuild from written instructions instead of memory.

- [ ] **Document how to export and restore each community-script service.** Start with NPM, AdGuard, Homepage, Uptime Kuma, and Audiobookshelf. **Estimate: 30–60 minutes per service.**
- [ ] **Add missing deployment files or recovery instructions.** Cover Paperless and Jellyfin after their actual configuration/data locations are confirmed. **Estimate: 1–3 hours per service.**
- [ ] **Create a read-only health-check script.** It should report node reachability, free disk space, NFS mounts, temperatures, failed services, guest status, endpoint status, and backup age. **Estimate: 2–4 hours.**
- [ ] **Choose a monthly update routine.** Record current versions, update one layer at a time, and write down how to roll back. **Estimate: 45–90 minutes to create; 1–2 hours per monthly maintenance session.**
- [x] **Update the Proxmox overview.** The old repository URL and obsolete service placements were corrected.

## 7. Clean up network access

- [ ] **Safely retire the old Pi-hole VM.** First confirm the router, DHCP settings, and manually configured devices no longer use `10.27.27.193`. Export Pi-hole's configuration before shutting it down. **Estimate: 45–90 minutes, followed by a few days powered off before deletion.**
- [ ] **Check for public port forwards.** Proxmox, NPM admin, AdGuard, Glances, and application admin pages should normally be available only through the LAN or Tailscale. **Estimate: 30–60 minutes.**
- [ ] **Review service accounts and API tokens.** Use separate accounts where possible, give them only the permissions they need, and rotate old credentials. **Estimate: 2–4 hours across the lab.**
- [ ] **Consider VLANs only after the earlier work is stable.** VLANs can separate servers, trusted devices, IoT devices, and guests, but they add troubleshooting complexity. **Estimate: 4–8 hours of planning and rollout, preferably across multiple sessions.**

## Verified during the audit

- Proxmox: `10.27.27.101`, `.102`, and `.103` on port `8006`
- AdGuard Home: `10.27.27.110`
- NPM admin: `10.27.27.111:81`
- Homepage: pve1 CT112 at `10.27.27.112:3000`
- Audiobookshelf: `10.27.27.112:13378`
- Uptime Kuma: pve1 CT119 at `10.27.27.119:3001`
- docker-arr VM210: `10.27.27.47`
- Jellyfin: `10.27.27.33:8096`
- Glances: port `61208` on all three Proxmox nodes

## How to use this list

For each work session:

1. Pick one small checkbox or one section.
2. Make a backup before changing a working service.
3. Test the direct IP first, then DNS, HTTP, and HTTPS.
4. Update `inventory/README.md` and `CURRENT_STATE.md` before stopping.
5. Record a rollback step for anything that changed live infrastructure.

This file is documentation only. Editing it does not change the live homelab.
