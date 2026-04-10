# pve1 LXC containers — front door / network core

pve1 (`10.27.27.101`) hosts the services that everything else depends on.

## Container summary

| CT ID | Name | IP | What runs inside |
|-------|------|----|-----------------|
| 100 | adguard-home | `10.27.27.110` | AdGuard Home — native systemd install |
| 101 | pve1-docker | `10.27.27.111` | Nginx Proxy Manager + Homepage via Docker Compose |

AdGuard Home runs natively (no Docker) — it's a single binary, designed for this.
NPM and Homepage share one Docker host LXC to avoid installing Docker twice.

Compose files live in `docker/` (the canonical home for all compose stacks):
- `docker/nginx-proxy-manager/`
- `docker/homepage/`

## Deploy order

1. **AdGuard Home first** — get DNS stable before anything else
2. **pve1-docker second** — NPM + Homepage come up together

## Prerequisites (run once on pve1)

Download the Debian 12 template if not already present:

```bash
pveam update
pveam download local debian-12-standard_12.7-1_amd64.tar.zst
```

Verify: `pveam list local`

## Deploying

```bash
git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab

# 1. AdGuard Home
cd ~/chaseworkslab/lxc/pve1/adguard-home
bash create-lxc.sh

# 2. Docker host (NPM + Homepage)
cd ~/chaseworkslab/lxc/pve1/docker
bash create-lxc.sh
```

## DNS cutover (after AdGuard Home is running)

1. Complete the AdGuard Home setup wizard at `http://10.27.27.110:3000`
2. Log into UniFi UX7 → change DHCP DNS from `10.27.27.193` to `10.27.27.110`
3. Verify: `nslookup google.com 10.27.27.110` from any client
4. Shut down Pi-hole UTM VM on MM1

## DNS rewrites to add in AdGuard Home

Settings → Filters → DNS rewrites:

| Domain | Answer |
|--------|--------|
| `pve1.chaseworkslab.com` | `10.27.27.101` |
| `pve2.chaseworkslab.com` | `10.27.27.102` |
| `pve3.chaseworkslab.com` | `10.27.27.103` |
| `adguard.chaseworkslab.com` | `10.27.27.110` |
| `*.chaseworkslab.com` | `10.27.27.111` |

The wildcard `*.chaseworkslab.com → 10.27.27.111` routes everything through NPM.
Add each service as a proxy host in NPM pointing to its backend IP:port.
