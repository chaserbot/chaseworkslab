# Next steps

Planned work, in-progress tasks, and ideas backlog.
Check off items as they are completed. Move finished items to DECISIONS.md.

## In progress

<!-- Tasks actively being worked on -->

## Track T1 — Proxmox cluster formation (high priority)

1. **Form the cluster**: Create cluster on pve1, join pve2 and pve3
   - `pvecm create chaseworkslab` on pve1
   - `pvecm add 10.27.27.31` on pve2 and pve3
   - Verify: `pvecm status`, `pvecm nodes`
   - Re-enable HA services on all three nodes
2. **Shared storage**: Expose Pegasus DAS from Mac Mini #1 via NFS; mount on all Proxmox nodes
   - Configure RAID on LittlePeggy and BigPeggy via Promise Utility
   - Enable NFS on Mac Mini #1 (`/etc/exports` with both volumes)
   - Mount `/mnt/littlepeggy` and `/mnt/bigpeggy` on each Proxmox node
   - Register as Proxmox datacenter storage (mark as shared, set content types)
   - Recommended folder structure: `proxmox/` (images, backup, iso), `media/` (movies, tv, music), `containers/` (app data)

## Track T2 — Private service access via Pi-hole + Tailscale + reverse proxy (after T1)

Goal: use stable names like `jellyfin.chaseworkslab.com` from home or anywhere in the world, but only over Tailscale (tailnet access first, then app login).

### Phase 1 — revive DNS foundation

1. Stand up Pi-hole LXC on Proxmox cluster (pve1 or pve2)
2. Assign same IP `10.27.27.193` to new LXC (update DHCP reservation on Luxul router)
3. Export Pi-hole config from UTM VM (blocklists, local DNS records, settings)
4. Import config into new LXC instance
5. Test DNS resolution from multiple clients before decommissioning UTM VM
6. Shut down UTM VM on Mac Mini #1

### Phase 2 — create a dedicated private front door

7. Create a dedicated reverse-proxy LXC (`edgeproxy` or similar) on the Proxmox cluster
8. Install:
   - Tailscale
   - Caddy (preferred) or Nginx Proxy Manager
9. Give the proxy LXC a stable LAN IP and join it to the tailnet
10. Record both its LAN IP and Tailscale IP in repo docs

### Phase 3 — private DNS and split DNS

11. Configure Pi-hole local DNS records so service names point to the reverse proxy, not directly to each backend
   - Example: `jellyfin.chaseworkslab.com` → proxy IP
   - Example: `grafana.chaseworkslab.com` → proxy IP
   - Example: `proxmox.chaseworkslab.com` → proxy IP
   - Example: `sonarr.chaseworkslab.com` → proxy IP
   - Example: `radarr.chaseworkslab.com` → proxy IP
   - Example: `prowlarr.chaseworkslab.com` → proxy IP
12. In Tailscale admin, configure DNS to use Pi-hole for private resolution
13. Prefer split-DNS behavior for `chaseworkslab.com` so these names resolve correctly on the tailnet without exposing services publicly

### Phase 4 — reverse proxy routing

14. Configure hostname-based proxy routes:
   - `jellyfin.chaseworkslab.com` → `http://<jellyfin-ip>:8096`
   - `grafana.chaseworkslab.com` → `http://<grafana-ip>:3000`
   - `proxmox.chaseworkslab.com` → `https://<pve-ip>:8006`
   - `sonarr.chaseworkslab.com` → `http://<sonarr-ip>:8989`
   - `radarr.chaseworkslab.com` → `http://<radarr-ip>:7878`
   - `prowlarr.chaseworkslab.com` → `http://<prowlarr-ip>:9696`
15. Test from:
   - home LAN
   - remote device on Tailscale
   - remote device not on Tailscale (should fail or stay private)

### Phase 5 — HTTPS cleanup

16. Add wildcard or per-host certs for `*.chaseworkslab.com` via DNS challenge if supported by DNS provider
17. Keep internal services non-public by default; avoid public port forwards unless there is a specific reason

### Notes

- DNS maps names to IPs, not ports; the reverse proxy handles backend port routing
- Use the reverse proxy as the stable front door so backend services can move later without changing URLs
- Security model: tailnet access first, then service authentication
- Start by proving the model with three services:
  - `jellyfin.chaseworkslab.com`
  - `grafana.chaseworkslab.com`
  - `proxmox.chaseworkslab.com`

## Track T3 — Commit Docker Compose files and migrate services (after T1)

### Step 1: Get compose files into git (do this first, before Proxmox migration)

1. SSH into Mac Mini #1, dump existing `docker-compose.yml` for each service
2. Sanitize (strip secrets), add `.env.example` with placeholder values, commit to repo:
   - arr stack (Sonarr, Radarr, Prowlarr, qBittorrent, Overseerr, Audiobookshelf) → `arr/`
   - Uptime Kuma → `docker/`
   - Paperless-ngx → `docker/`
3. Assign static IP to Ace Magician CK10; document in STACK.md
4. Dockerize Jellyfin (if not already); commit `docker-compose.yml` to `docker/`
5. Confirm how Jellyfin accesses Pegasus DAS media (NFS from Mac Mini #1, or direct mount?)
6. Verify Intel Quick Sync hardware transcoding in Jellyfin config

### Step 2: Migrate services to Proxmox LXC

- Move arr stack: LXC on Proxmox cluster, re-attach Pegasus DAS media paths via NFS
- Move Jellyfin: LXC on Proxmox with iGPU passthrough TBD (Mac Mini A1347 Intel iGPU feasibility unknown)
- Because everything is in Docker Compose: migration = copy `docker-compose.yml`, update volume paths, spin up

## Track T4 — Monitoring stack (after T1)

1. Deploy Prometheus + Grafana on Proxmox cluster (LXC or VM)
2. Add Node Exporter to each Proxmox node (via post-install script or Ansible playbook)
3. Add cAdvisor for Docker container metrics (optional)
4. Build dashboards: per-node system health, Docker container status, arr stack health
5. Configure Proxmox metrics scrape (Proxmox exporter or built-in PVE metrics endpoint)
6. Configure alerting (Grafana alerts → notification channel TBD)

## Track T5 — LLM stack / FATFISH (after T1)

FATFISH is a self-hosted AI assistant for Fatfish (Chase's event production company).
Repo: `github.com/chaserbot/ff-assistant-starter` (private, early stage)

1. Decide on host for LLM inference (Proxmox LXC/VM, or Ace Magician CK10 for CPU inference)
2. Deploy Ollama + Open WebUI via Docker Compose; commit to `llm/`
3. Pull initial models (llama3, mistral, etc.) and test inference
4. Connect Open WebUI to Ollama
5. Wire Ollama API into n8n for FATFISH automation pipelines
6. Intended FATFISH capabilities:
   - Quoting assistance (job costing, proposal generation)
   - Client nurturing (follow-up drafts, communication templates)
   - Team communication workflows

## Network / DNS backlog

- Consider VLAN segmentation: IoT vs. servers vs. personal devices (low priority — defer until Proxmox stable)
- Configure `chaseworkslab.com` split-horizon DNS (internal via Pi-hole; external via Tailscale or reverse proxy)

---

## Deferred tasks from monorepo migration

### 1. Audit and update internal path references in each subfolder

After migration from standalone repos to this monorepo, some scripts and docs
may still reference the old file structure or standalone clone paths.

Known example: the Proxmox post-install script broke previously due to
assumed file paths that no longer matched reality. Each subfolder needs a
pass to:
- Update any hardcoded paths (e.g. `~/chaseworkslab-proxmox` → `~/chaseworkslab/proxmox`)
- Update clone URLs if scripts reference the old per-repo GitHub URLs
- Fix any relative path assumptions in shell scripts

Priority: high — do this before relying on any subfolder script in production.

### 2. Add copy-paste quick-start sections to each subfolder README

Each subfolder's README.md should have a prominent "Getting Started" section
near the top with copy-paste install/clone commands — the same way a
well-maintained open-source tool presents its installation instructions.

Template structure for each subfolder README:

    ## Quick start

    Clone the monorepo (if you haven't already):

        git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab

    Then run the install/setup script:

        cd ~/chaseworkslab/<subfolder>
        bash <install-script>.sh

Priority: medium — improves usability on new machines.
