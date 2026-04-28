# pve_exporter setup

Runs in its own LXC at `10.27.27.139` (pve3), installed via the community
helper script. Exposes Proxmox API metrics for all three nodes via the
multi-target scrape config in `prometheus.yml`.

## 1. Create a read-only PVE API token

On any Proxmox node (or via the web UI on pve1):

```bash
# Create a dedicated user (do this once)
pveum user add prometheus@pve --comment "Prometheus scraper"

# Create a token — copy the secret shown, you cannot retrieve it again
pveum user token add prometheus@pve prometheus --privsep 1

# Grant read-only role to both the backing user and the separated token.
# With --privsep 1, token permissions are the intersection of user + token ACLs.
pveum acl modify / --users prometheus@pve --roles PVEAuditor
pveum acl modify / --tokens 'prometheus@pve!prometheus' --roles PVEAuditor
```

The token ID will be `prometheus@pve!prometheus`.
Quote the token ID whenever it appears in a shell command; otherwise Bash treats
`!prometheus` as history expansion.

## 2. Install prometheus-pve-exporter LXC

Run the community script from a Proxmox node shell, not from inside an existing
container:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/prometheus-pve-exporter.sh)"
```

Use the interactive prompts to create the exporter LXC at `10.27.27.139`.
The community script exposes the exporter on port `9221`.

## 3. Configure prometheus-pve-exporter

After the LXC is created, SSH into it and add the Proxmox API token config.
Keep the token secret only on the LXC; do not commit it to this repo.

```bash
ssh root@10.27.27.139

cat > /opt/prometheus-pve-exporter/pve.yml <<EOF
default:
  user: prometheus@pve
  token_name: prometheus
  token_value: <paste-token-secret-here>
  verify_ssl: false
EOF

chmod 600 /opt/prometheus-pve-exporter/pve.yml
```

## 4. Restart the service

```bash
systemctl restart prometheus-pve-exporter
systemctl status prometheus-pve-exporter
```

## 5. Verify

```bash
# Test pve1 target manually
curl "http://localhost:9221/pve?target=10.27.27.101"
```

The Prometheus scrape config in `prometheus.yml` passes each PVE node IP as
`?target=<ip>` and rewrites `__address__` to `10.27.27.139:9221` so all three
nodes are scraped via this single exporter instance.
