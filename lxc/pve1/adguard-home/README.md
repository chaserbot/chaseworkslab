# AdGuard Home LXC — pve1

DNS ad-blocker. Replaces the Pi-hole UTM VM on MM1.

## Deploy

Run this on pve1:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/adguard.sh)"
```

## Values to enter when prompted

| Prompt | Value |
| ------ | ----- |
| CT ID | `110` |
| Hostname | `adguard-home` |
| IP Address | `10.27.27.110/24` |
| Gateway | `10.27.27.1` |

Accept defaults for everything else (RAM, disk, OS).

## After deploy

1. Complete the setup wizard at `http://10.27.27.110:3000`
   - Set an admin username and password
   - Confirm DNS is on port 53
2. Add DNS rewrites under Settings → Filters → DNS rewrites:

| Domain | Answer |
| ------ | ------ |
| `pve1.chaseworkslab.com` | `10.27.27.101` |
| `pve2.chaseworkslab.com` | `10.27.27.102` |
| `pve3.chaseworkslab.com` | `10.27.27.103` |
| `adguard.chaseworkslab.com` | `10.27.27.110` |
| `*.chaseworkslab.com` | `10.27.27.111` |

3. Log into UniFi UX7 → change DHCP DNS from `10.27.27.193` to `10.27.27.110`
4. Verify: `nslookup google.com 10.27.27.110` from any client
5. Shut down the Pi-hole UTM VM on MM1
