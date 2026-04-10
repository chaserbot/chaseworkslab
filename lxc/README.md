# LXC containers

Proxmox LXC provisioning scripts for the chaseworkslab cluster.
Each subfolder corresponds to a Proxmox node.

**LXC scripts are for provisioning only** — they create the container and
install the runtime. Docker Compose service definitions live in `docker/`.

## Structure

```
lxc/
  pve1/
    adguard-home/   CT100 — native AdGuard Home install (no Docker)
    docker/         CT101 — shared Docker host for NPM + Homepage
  pve2/             planned: media apps (arr stack)
  pve3/             planned: ops (monitoring, automation, documents)
```

## Container IP scheme

| Range | Node | Purpose |
|-------|------|---------|
| `10.27.27.110–119` | pve1 | Front door (DNS, proxy, dashboard) |
| `10.27.27.120–129` | pve2 | Media apps |
| `10.27.27.130–139` | pve3 | Ops / monitoring / automation |

See `inventory/README.md` for full IP and port reference.

## Workflow

```bash
# On the target Proxmox node:
git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab
cd ~/chaseworkslab/lxc/<node>/<service>
bash create-lxc.sh
```
