---
name: Monitoring stack architecture
description: Prometheus scrape config, exporter LXC IPs, and config file locations on pve3
type: project
---

# Monitoring stack architecture

Prometheus scrape config is fully built and committed. All monitoring exporters are deployed as individual LXCs on pve3 via community helper scripts.

**Why:** Keeps arr compose clean, each exporter independently manageable, credentials isolated per LXC.

**How to apply:** When referencing monitoring IPs/ports or adding new scrape targets, use these values. Do not guess IPs from memory — confirm against inventory/README.md.

## IPs and ports (all on pve3, 10.27.27.103)

|Service|IP|Port|Status|
|---|---|---|---|
|Prometheus|10.27.27.130|9090|Config ready; LXC deploy pending|
|pve_exporter|10.27.27.139|9221|Running|
|Blackbox exporter|10.27.27.136|9115|Planned|
|qbittorrent-exporter|10.27.27.137|8090|LXC up; needs password in env file|
|cAdvisor|10.27.27.47|8085|Running on docker-arr VM|
|Exportarr Radarr|10.27.27.47|9707|Planned docker-arr Compose sidecar|
|Exportarr Sonarr|10.27.27.47|9708|Planned docker-arr Compose sidecar|
|Exportarr Prowlarr|10.27.27.47|9709|Planned docker-arr Compose sidecar|

## Config file locations (in this repo)

- Prometheus scrape config: `monitoring/prometheus/prometheus.yml`
- pve_exporter setup guide: `monitoring/prometheus/pve-exporter-setup.md`
- Blackbox config template: `monitoring/blackbox/blackbox.yml`
- qbittorrent-exporter env template: `monitoring/qbittorrent-exporter/qbittorrent-exporter.env`

## Config file locations (on LXCs)

- Prometheus: `/etc/prometheus/prometheus.yml`
- pve_exporter: `/opt/prometheus-pve-exporter/pve.yml`
- Blackbox exporter: `/etc/blackbox_exporter/blackbox.yml`
- qbittorrent-exporter: `/opt/qbittorrent-exporter.env`

## Pending actions (as of 2026-04-22)

1. Fill in Exportarr API keys (Sonarr/Radarr/Prowlarr) in docker-arr `.env` and restart the Compose sidecars
2. Fill in qBittorrent password in exporter env file and restart service
3. Deploy Prometheus LXC and copy config file
4. Deploy Grafana LXC (IP not yet assigned)
5. Install node_exporter on pve1/2/3 bare metal, MM1, CK10, docker-arr VM
