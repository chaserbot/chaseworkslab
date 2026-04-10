# LXC containers

Proxmox LXC definitions for the chaseworkslab cluster.
Each subfolder corresponds to a Proxmox node. Each service has its own
directory with a `create-lxc.sh` provisioning script and a `docker-compose.yml`.

## Structure

```
lxc/
  pve1/     front door — AdGuard Home, Nginx Proxy Manager, Homepage
  pve2/     media apps — arr stack, Overseerr, Audiobookshelf (planned)
  pve3/     ops — Uptime Kuma, Prometheus, Grafana, n8n, Paperless-ngx (planned)
```

## Workflow

1. SSH into the target Proxmox node
2. Clone this repo: `git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab`
3. `cd ~/chaseworkslab/lxc/<node>/<service>`
4. `bash create-lxc.sh`

## Container IP scheme

| Range | Node | Purpose |
|-------|------|---------|
| `10.27.27.110–119` | pve1 | Front door (DNS, proxy, dashboard) |
| `10.27.27.120–129` | pve2 | Media apps |
| `10.27.27.130–139` | pve3 | Ops / monitoring / automation |

See `inventory/README.md` for full IP reference.
