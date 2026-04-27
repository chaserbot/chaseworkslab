# Prometheus — LXC on pve3

- **Host:** pve3 (`10.27.27.103`)
- **LXC IP:** `10.27.27.130`
- **Port:** `9090`
- **Config file:** `/etc/prometheus/prometheus.yml` inside the LXC
- **Data dir:** `/var/lib/prometheus` (default for apt install) or `/prometheus` if installed manually

## Deploying the config

Copy `prometheus.yml` from this repo into the LXC:

```bash
scp monitoring/prometheus/prometheus.yml root@10.27.27.130:/etc/prometheus/prometheus.yml
```

Then reload (no restart needed if `--web.enable-lifecycle` is set):

```bash
curl -X POST http://10.27.27.130:9090/-/reload
```

Or restart the service:

```bash
ssh root@10.27.27.130 systemctl restart prometheus
```

## Verifying targets

Open <http://10.27.27.130:9090/targets> in a browser after deploy.
Each exporter target should show State = UP within one scrape interval (30s).

## pve_exporter note

`pve_exporter` is listed in the config but needs to be separately installed and given a
read-only Proxmox API token before its job will work. Comment it out if not yet set up.

## Pending credential-backed exporters

`exportarr` and `qbittorrent` are listed in the config, but they will stay DOWN until
their credentials are configured:

- Exportarr: Arr API keys in `arr/.env` on the docker-arr VM (`10.27.27.47`)
- qbittorrent-exporter: `/opt/qbittorrent-exporter.env` on `10.27.27.137`

## Blackbox exporter note

Blackbox exporter is planned at `10.27.27.136:9115`. Until that LXC is deployed and
`monitoring/blackbox/blackbox.yml` is copied into place, the `blackbox_http` and
`blackbox_tcp` jobs will show as DOWN.
