---
name: Exporter LXCs over Docker sidecars
description: Prometheus exporters should be deployed as individual LXCs, not Docker sidecars in the arr compose
type: feedback
---

When adding a Prometheus exporter for a service in this homelab, deploy it as its own LXC (via community script) rather than adding a Docker sidecar container to an existing compose file.

**Why:** Keeps compose files clean and focused on the service they define. LXCs are independently manageable and restartable. Credentials stay isolated per LXC. This was explicitly chosen over the Docker sidecar approach for pve_exporter, Scraparr, and qbittorrent-exporter.

**How to apply:** Before adding an exporter as a Docker service in a compose file, check if a community script LXC exists for it. If it does, recommend that path instead. Only use Docker sidecars if no LXC option exists.
