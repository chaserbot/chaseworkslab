# Proxmox — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Three-node Proxmox VE cluster built on 2014 Mac Mini A1347s. Goal is to replace the single Mac Mini #1 (macOS) as the primary compute layer for homelab services — running LXC containers and VMs distributed across the cluster.

## Current State
- **pve1, pve2, pve3**: All three nodes are installed and post-install complete
- **Clustering**: Not yet formed — next major step
- **Storage**: Pegasus DAS (Thunderbolt → Mac Mini #1) targeted as shared NFS storage for the cluster — not yet connected

## Hosts

| Node | Hostname | IP | Status |
|---|---|---|---|
| pve1 | Mac Mini #2 (A1347) | 10.27.27.31 | Post-install complete |
| pve2 | Mac Mini #3 (A1347) | 10.27.27.32 | Post-install complete |
| pve3 | Mac Mini #4 (A1347) | 10.27.27.33 | Post-install complete |

## Post-Install Script
Automated via `chaseworkslab-proxmox` repo. Run on each node as:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/chaserbot/chaseworkslab-proxmox/main/proxmox/post-install.sh) <node-number>
```

**What the script does (Mac Mini A1347 specifics):**
- Installs `mbpfan`, `applesmc`, `coretemp` for thermal management
- Creates `mac-autoboot` systemd service (prevents hang on power loss)
- Standard Proxmox post-install: disables enterprise repo, enables no-sub repo, removes subscription nag, updates packages

## Key Config Details
- All nodes: Proxmox VE (latest at time of install)
- Hardware: Mac Mini A1347 — Intel Core i5/i7, 16GB RAM typical, spinning HDD (upgrade path TBD)
- Network: Static IPs assigned via Luxul router DHCP reservations
- No GPU passthrough (no dGPU in these units)
- Web UI accessible at `https://10.27.27.3[1-3]:8006`

## Related GitHub Repo
`github.com/chaserbot/chaseworkslab-proxmox`

File structure:
```
proxmox/
  post-install.sh     ← main script
  README.md
```

## Next Steps
1. **Form the cluster** — join pve2 and pve3 to pve1 as cluster master
2. **Shared storage** — expose Pegasus DAS from Mac Mini #1 via NFS, mount in Proxmox cluster as shared storage pool
3. **Migrate services** — move containers off Mac Mini #1 (macOS) onto Proxmox cluster LXCs
4. **Document LXC templates** in `chaseworkslab-lxc` repo as they're created
