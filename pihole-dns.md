# Pi-hole & DNS — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Pi-hole handles DNS for the entire local network — ad blocking, local DNS resolution, and DHCP-adjacent DNS. Currently running as a UTM virtual machine on Mac Mini #1 (macOS). Plan is to migrate it to a lightweight LXC container on the Proxmox cluster.

## Current State
- **Running**: Yes — active and handling DNS for all local devices
- **Platform**: UTM VM on Mac Mini #1 (macOS, `10.27.27.22`)
- **IP**: `10.27.27.193`
- **Fragility**: UTM VM is less reliable than LXC — tied to macOS host, no HA

## Host
- **Current**: Mac Mini #1 (`10.27.27.22`) — UTM VM
- **Planned**: Proxmox LXC (one of pve1/pve2/pve3)
- **Pi-hole IP**: `10.27.27.193` (should stay the same after migration — update DHCP reservation)

## Key Config Details
- Router (Luxul ABR-5000) configured to push `10.27.27.193` as DNS to all DHCP clients
- Pi-hole admin UI accessible at `http://10.27.27.193/admin`
- Local DNS records for homelab services should be configured here (pending — not yet set up)
- Upstream DNS: likely Cloudflare (`1.1.1.1`) or similar — confirm in Pi-hole settings

## Domain Plan
`chaseworkslab.com` will be used for internal service DNS once configured:
- Example: `proxmox.chaseworkslab.com` → `10.27.27.31`
- Example: `jellyfin.chaseworkslab.com` → Ace Magician IP
- Pi-hole local DNS records will handle these mappings

## Related GitHub Repo
Pi-hole LXC config will live in `github.com/chaserbot/chaseworkslab-lxc`:
```
pihole/
  README.md
  setup.sh (or Ansible playbook stub)
```

## Migration Plan (Track T2)
1. Stand up Pi-hole LXC on Proxmox cluster (pve1 or pve2)
2. Assign same IP `10.27.27.193` to new LXC (update DHCP reservation)
3. Export Pi-hole config (blocklists, local DNS records, settings) from UTM VM
4. Import config into new LXC instance
5. Test DNS resolution before decommissioning UTM VM
6. Shut down UTM VM on Mac Mini #1

## Next Steps
1. Wait for Proxmox cluster to be formed (Track T1 prerequisite)
2. Create Pi-hole LXC template in `chaseworkslab-lxc`
3. Configure local DNS records for `chaseworkslab.com` internal services
4. Deploy Tailscale alongside or after Pi-hole migration
