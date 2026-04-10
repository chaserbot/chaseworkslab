# LXC containers

Proxmox LXC provisioning for the chaseworkslab cluster.
Each subfolder corresponds to a Proxmox node and service.

All containers are deployed using the [Proxmox VE community helper scripts](https://github.com/community-scripts/ProxmoxVE). Each service folder has a README with the exact command to run and the values to enter when prompted.

## Structure

```text
lxc/
  pve1/
    adguard-home/    CT110 — AdGuard Home (native install)
    nginx-proxy-manager/  CT101 — Nginx Proxy Manager (native install)
    homepage/        CT102 — Homepage dashboard (native Node.js install)
  pve2/              planned: media apps (arr stack)
  pve3/              planned: ops (monitoring, automation, documents)
```

## Container IP scheme

| Range | Node | Purpose |
| ----- | ---- | ------- |
| `10.27.27.110–119` | pve1 | Front door (DNS, proxy, dashboard) |
| `10.27.27.120–129` | pve2 | Media apps |
| `10.27.27.130–139` | pve3 | Ops / monitoring / automation |

See `inventory/README.md` for full IP and port reference.

## Deploy order on pve1

1. **AdGuard Home** first — get DNS stable before anything else
2. **Nginx Proxy Manager** second — reverse proxy needs to be up before adding proxy hosts
3. **Homepage** last — proxied through NPM

See each service's README for the exact command and prompt values.
