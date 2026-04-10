# pve1 LXC containers — front door / network core

pve1 (`10.27.27.101`) hosts the services that everything else depends on:
DNS, reverse proxy, and dashboard. Deploy these first, in order.

## Container summary

| CT ID | Service | IP | Port(s) | Notes |
|-------|---------|----|---------|----|
| 100 | AdGuard Home | `10.27.27.110` | 53 (DNS), 80 (web UI) | DNS + ad blocking; replace Pi-hole UTM VM |
| 101 | Nginx Proxy Manager | `10.27.27.111` | 80, 443, 81 (admin) | Reverse proxy for all services |
| 102 | Homepage | `10.27.27.112` | 3000 | Dashboard |

## Deploy order

1. **AdGuard Home first** — once it's up, point your router DNS to `10.27.27.110` and retire the Pi-hole UTM VM
2. **Nginx Proxy Manager second** — establishes the stable front door URL for all services
3. **Homepage last** — depends on NPM being up to proxy `homepage.chaseworkslab.com`

## Prerequisites (run once on pve1)

Download the Debian 12 template if you haven't already:

```bash
pveam update
pveam download local debian-12-standard_12.7-1_amd64.tar.zst
```

Verify it's there:

```bash
pveam list local
```

## Deploying a container

Clone the repo on pve1, then run the create script for each service:

```bash
git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab
cd ~/chaseworkslab/lxc/pve1/<service>
bash create-lxc.sh
```

## DNS cutover (after AdGuard Home is running)

1. Log into your Luxul ABR-5000
2. Change the DNS server pushed to DHCP clients from `10.27.27.193` → `10.27.27.110`
3. Verify with `nslookup google.com 10.27.27.110` from any client
4. Once confirmed stable, you can shut down the Pi-hole UTM VM on MM1

## Post-NPM: DNS rewrites to configure in AdGuard Home

Add these under AdGuard Home → Filters → DNS rewrites:

| Domain | Answer |
|--------|--------|
| `pve1.chaseworkslab.com` | `10.27.27.101` |
| `pve2.chaseworkslab.com` | `10.27.27.102` |
| `pve3.chaseworkslab.com` | `10.27.27.103` |
| `adguard.chaseworkslab.com` | `10.27.27.110` |
| `*.chaseworkslab.com` | `10.27.27.111` |

The wildcard `*.chaseworkslab.com → 10.27.27.111` means NPM handles all routing.
Add each service as a proxy host in NPM pointing to its backend IP:port.
