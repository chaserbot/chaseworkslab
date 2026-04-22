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

# Grant read-only role to the token
pveum aclmod / -user prometheus@pve!prometheus -role PVEAuditor
```

The token ID will be `prometheus@pve!prometheus`.

## 2. Install pve_exporter in the exporter LXC

```bash
ssh root@10.27.27.139

apt-get update && apt-get install -y python3-pip python3-venv

python3 -m venv /opt/pve_exporter
/opt/pve_exporter/bin/pip install prometheus-pve-exporter
```

## 3. Configure pve_exporter

```bash
mkdir -p /etc/pve_exporter
cat > /etc/pve_exporter/pve.yml <<EOF
default:
  user: prometheus@pve
  token_name: prometheus
  token_value: <paste-token-secret-here>
  verify_ssl: false
EOF

chmod 600 /etc/pve_exporter/pve.yml
```

## 4. Create a systemd service

```bash
cat > /etc/systemd/system/pve_exporter.service <<EOF
[Unit]
Description=Prometheus Proxmox VE Exporter
After=network.target

[Service]
User=root
ExecStart=/opt/pve_exporter/bin/pve_exporter --config.file /etc/pve_exporter/pve.yml --web.listen-address 0.0.0.0:9221
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now pve_exporter
```

## 5. Verify

```bash
# Check service
systemctl status pve_exporter

# Test pve1 target manually
curl "http://localhost:9221/pve?target=10.27.27.101"
```

The Prometheus scrape config in `prometheus.yml` passes each PVE node IP as
`?target=<ip>` and rewrites `__address__` to `localhost:9221` so all three
nodes are scraped via this single exporter instance.
