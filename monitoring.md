# Monitoring — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Monitoring stack (Grafana + Prometheus) is planned but not yet deployed. Uptime Kuma is currently running on Mac Mini #1 as a lightweight uptime/health check tool. Full observability (metrics, dashboards, alerting) will come when the Proxmox cluster is stable.

## Current State

| Tool | Status | Host |
|---|---|---|
| Uptime Kuma | Running | Mac Mini #1 (`10.27.27.22`) |
| Grafana | Not yet deployed | — |
| Prometheus | Not yet deployed | — |
| Node Exporter | Not yet deployed | — |

## Planned Stack
- **Prometheus**: Metrics scraping and storage
- **Grafana**: Dashboards and visualization
- **Node Exporter**: Per-host system metrics (CPU, RAM, disk, network) — runs on each Proxmox node and Mac Mini
- **cAdvisor** (optional): Docker container metrics
- **Proxmox integration**: Prometheus can scrape Proxmox metrics via the Proxmox exporter or built-in PVE metrics

## Uptime Kuma
- Running in Docker on Mac Mini #1
- Monitors uptime/availability of services via HTTP checks and ping
- Web UI accessible at: TBD (needs static URL documented)
- **Action needed**: Commit `docker-compose.yml` to `chaseworkslab-docker`

## Planned Host
Monitoring stack will run on Proxmox cluster — either as an LXC container or VM.

## Related GitHub Repo
`github.com/chaserbot/chaseworkslab-monitoring`

Planned structure:
```
chaseworkslab-monitoring/
  docker-compose.yml    ← Grafana + Prometheus + exporters
  prometheus/
    prometheus.yml      ← scrape configs
  grafana/
    dashboards/         ← exported dashboard JSON files
  .env.example
  README.md
```

## Next Steps
1. Commit Uptime Kuma compose file to `chaseworkslab-docker`
2. After Proxmox cluster is formed (Track T1), deploy Prometheus + Grafana
3. Add Node Exporter to each Proxmox node via the `chaseworkslab-proxmox` post-install script or separate playbook
4. Build dashboards: per-node system health, Docker container status, arr stack health
5. Configure alerting (Grafana alerts → notification channel TBD)
