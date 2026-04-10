# pve1 LXC containers — front door / network core

pve1 (`10.27.27.101`) hosts the services that everything else depends on.

All containers are deployed using the [community helper scripts](https://github.com/community-scripts/ProxmoxVE) — no custom template management needed.

## Container summary

| CT ID | Name | IP | What runs inside |
| ----- | ---- | -- | ---------------- |
| 110 | adguard-home | `10.27.27.110` | AdGuard Home — native install |
| 101 | nginx-proxy-manager | `10.27.27.111` | Nginx Proxy Manager — native install |
| 102 | homepage | `10.27.27.112` | Homepage dashboard — native Node.js install |

## Deploy order

1. **AdGuard Home first** — get DNS stable before anything else
2. **NPM second** — reverse proxy needs to be up before adding proxy hosts
3. **Homepage last** — proxied through NPM

## Deploying

Each service has its own README with the exact command to run and the values to enter when prompted. See:

- [adguard-home/README.md](adguard-home/README.md)
- [nginx-proxy-manager/README.md](nginx-proxy-manager/README.md)
- [homepage/README.md](homepage/README.md)

## DNS cutover (after AdGuard Home is running)

1. Complete the AdGuard Home setup wizard at `http://10.27.27.110:3000`
2. Log into UniFi UX7 → change DHCP DNS from `10.27.27.193` to `10.27.27.110`
3. Verify: `nslookup google.com 10.27.27.110` from any client
4. Shut down Pi-hole UTM VM on MM1

## DNS rewrites to add in AdGuard Home

Settings → Filters → DNS rewrites:

| Domain | Answer |
| ------ | ------ |
| `pve1.chaseworkslab.com` | `10.27.27.101` |
| `pve2.chaseworkslab.com` | `10.27.27.102` |
| `pve3.chaseworkslab.com` | `10.27.27.103` |
| `adguard.chaseworkslab.com` | `10.27.27.110` |
| `*.chaseworkslab.com` | `10.27.27.111` |

The wildcard `*.chaseworkslab.com → 10.27.27.111` routes everything through NPM.
Add each service as a proxy host in NPM pointing to its backend IP:port.

## NPM proxy hosts to add (after DNS rewrites)

| Domain | Backend |
| ------ | ------- |
| `npm.chaseworkslab.com` | `http://10.27.27.111:81` |
| `homepage.chaseworkslab.com` | `http://10.27.27.112:3000` |
| `adguard.chaseworkslab.com` | `http://10.27.27.110:80` |
