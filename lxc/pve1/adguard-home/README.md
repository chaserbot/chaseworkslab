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
2. Add DNS rewrites under Settings → Filters → DNS rewrites — individual entry per service:

| Domain | Answer |
| ------ | ------ |
| `pve1.chaseworkslab.com` | `10.27.27.101` |
| `pve2.chaseworkslab.com` | `10.27.27.102` |
| `pve3.chaseworkslab.com` | `10.27.27.103` |
| `jellyfin.chaseworkslab.com` | `10.27.27.111` |
| *(add more as NPM entries are created)* | `10.27.27.111` |

See `../dns-proxy-entries.md` for the full list to build out.

3. Log into UniFi UX7 → change DHCP DNS from `10.27.27.193` to `10.27.27.110`
4. Verify: `nslookup google.com 10.27.27.110` from any client
5. Shut down the Pi-hole UTM VM on MM1

---

## Backup and migration

### Export via web UI

Settings (gear icon) → General Settings → scroll to bottom → **Export configuration**

Downloads `AdGuardHome.yaml` — contains all settings, blocklists/allowlists, DNS rewrites, filtering rules, client config. To restore: same page, **Import configuration**.

### Export via SSH (more reliable, scriptable)

```bash
# Pull config from the LXC
scp root@10.27.27.110:/opt/AdGuardHome/AdGuardHome.yaml ./AdGuardHome.yaml
```

### Restore to a fresh LXC

```bash
# After running the community script and completing the wizard:
systemctl stop AdGuardHome
scp ./AdGuardHome.yaml root@10.27.27.110:/opt/AdGuardHome/AdGuardHome.yaml
systemctl start AdGuardHome
```

Blocklist URLs are stored in the yaml — they re-download automatically on startup.

### Keep a copy in this repo

Commit your exported yaml to this directory:

```
lxc/pve1/adguard-home/AdGuardHome.yaml
```

Before committing, open the file and check for the `password:` field under `users:` — it's a bcrypt hash (not plaintext), so it's safe to commit. The file contains no other secrets.

```bash
# Quick check — should show a bcrypt hash like $2y$...
grep password /opt/AdGuardHome/AdGuardHome.yaml
```

Add to `.gitignore` only if you decide you don't want admin credentials (even hashed) in the repo.
