# Blackbox exporter

Lightweight synthetic checks for important homelab HTTP and TCP endpoints.

- **Host:** pve3 (`10.27.27.103`)
- **LXC IP:** `10.27.27.136`
- **Port:** `9115`
- **Config file:** `/etc/blackbox_exporter/blackbox.yml` inside the LXC

## Deploying the config

Copy `blackbox.yml` from this repo into the LXC:

```bash
scp monitoring/blackbox/blackbox.yml root@10.27.27.136:/etc/blackbox_exporter/blackbox.yml
```

Then restart the service:

```bash
ssh root@10.27.27.136 systemctl restart blackbox_exporter
```

Prometheus probes the Blackbox exporter at `10.27.27.136:9115`; Blackbox then probes the target URLs and TCP ports listed in `monitoring/prometheus/prometheus.yml`.
