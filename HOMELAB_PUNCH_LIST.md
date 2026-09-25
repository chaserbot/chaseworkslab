# Homelab punch list

Audit date: 2026-09-25

This is the ordered remediation list from a repository review plus read-only LAN checks. An HTTP response confirms reachability, not application health, authentication, backups, or data integrity.

## 1. Protect recoverability first

- [ ] Define and test backups for every stateful service: Proxmox guest configs/disks, Homepage config and `.env`, NPM data/certificates, AdGuard config, arr appdata, Uptime Kuma, Paperless, and Jellyfin metadata.
- [ ] Keep backup copies off MM1. Both Proxmox shared storage mounts depend on MM1 and its attached DAS, so a single MM1 failure currently affects storage and any backups stored there.
- [ ] Perform one documented restore drill and record recovery time and required secrets.

## 2. Fix HTTPS on internal service names

- [ ] HTTP routing through NPM works for `homepage`, `jellyfin`, `sonarr`, `radarr`, `prowlarr`, `seerr`, `qbit`, `audiobooks`, `paperless`, and `uptime`.
- [ ] HTTPS connections to names resolving internally to `10.27.27.111` failed during the audit. Configure certificates and SSL proxy hosts, or explicitly document an HTTP-only policy.
- [ ] After fixing, enable Force SSL and HSTS only after confirming every route and certificate; avoid HSTS during initial testing because it is sticky in browsers.

## 3. Resolve service-location drift

- [x] Correct the Audiobookshelf backend to `10.27.27.112:13378`; documentation and Homepage config updated.
- [ ] Identify the actual Paperless backend. The documented `10.27.27.22:8000` endpoint did not respond, but `http://paperless.chaseworkslab.com` did.
- [x] Confirm Uptime Kuma's completed move to pve1 CT119 and remove remaining MM1/pve3 migration language from current-state documentation.
- [x] Replace old MM1 arr targets and current-state Overseerr references with the docker-arr VM (`10.27.27.47`) and Seerr.

## 4. Finish monitoring and alert delivery

- [ ] In Uptime Kuma, monitor all three Proxmox UIs, DNS on AdGuard (TCP/UDP 53), NPM HTTP/HTTPS, Homepage, the arr apps, Jellyfin, both NFS exports, and the MM1 host.
- [ ] Configure at least one external notification path and test it by intentionally stopping a noncritical monitor target.
- [ ] Add disk-capacity, SMART/DAS health, NFS mount, backup-age, certificate-expiry, and UPS/power alerts. HTTP-only checks will miss the failures most likely to lose data.
- [ ] Verify Glances is intentionally exposed on `0.0.0.0:61208`; restrict it to the management LAN/firewall if possible.

## 5. Remove single points of failure where practical

- [ ] Decide whether AdGuard needs a second resolver. One DNS LXC on one node means maintenance or failure can interrupt name resolution for the whole LAN.
- [ ] Decide whether pve1 should remain both the network front door and Tailscale subnet router; document emergency direct-IP access if it is down.
- [ ] Add a UPS and graceful shutdown plan for MM1, both Pegasus arrays, network gear, and the Proxmox nodes if one is not already present.

## 6. Make deployments reproducible

- [ ] Commit sanitized deployment definitions for Uptime Kuma, Paperless, Audiobookshelf, Jellyfin, NPM, and AdGuard, or document exact backup/restore procedures for community-script installs.
- [ ] Add an Ansible playbook or read-only audit script for package status, disk space, mounts, temperatures, failed systemd units, guest status, and backup age.
- [ ] Pin or record tested versions and add an update cadence with rollback notes.
- [ ] Replace the stale standalone-repo URL and old service layout in `proxmox/README.md` before using it for disaster recovery.

## 7. Clean up network and access policy

- [ ] Remove the old Pi-hole VM only after verifying no DHCP/static client still uses `10.27.27.193` and after exporting its configuration.
- [ ] Keep admin interfaces private to LAN/Tailscale; verify no router port forwards expose NPM admin, Proxmox, AdGuard, Glances, or app admin ports publicly.
- [ ] Use individual least-privilege service accounts/API tokens and rotate any long-lived credentials that predate the current layout.
- [ ] Defer VLAN work until backups, monitoring, and documentation are reliable; then separate infrastructure, trusted clients, IoT, and guest traffic.

## Verified during this audit

- Proxmox UIs: `10.27.27.101`, `.102`, `.103` on port 8006
- Front door: AdGuard `10.27.27.110`, NPM `10.27.27.111:81`, Homepage CT112 `10.27.27.112:3000`
- Operations: Uptime Kuma CT119 `10.27.27.119:3001`; Glances on all three Proxmox nodes
- Apps: docker-arr VM `10.27.27.47` (Seerr, Sonarr, Radarr, Prowlarr, qBittorrent) and Jellyfin `10.27.27.33:8096`

## Rollback

This audit changed documentation only. Revert the 2026-09-25 documentation commit (or restore the affected Markdown files from git) to undo it; no live homelab state was changed.
