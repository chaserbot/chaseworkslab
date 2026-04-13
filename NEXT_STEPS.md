# Next steps

Planned work, in-progress tasks, and ideas backlog.
Check off items as they are completed. Move finished items to DECISIONS.md.

## In progress

<!-- Tasks actively being worked on -->

### Workspace and deployment workflow reset

1. Consolidate active homelab authoring around the repo, not ad hoc editing on hosts
2. Use local VS Code as the primary editor
3. Use GitHub as the source of truth for docker compose files, Ansible playbooks, scripts, and docs
4. Use GitHub Codespaces only as an optional remote fallback, not the default workflow
5. Pull or deploy files to hosts intentionally as needed rather than building directly inside helper editors on the hosts

## Track T1 — Proxmox cluster formation (high priority)

1. ~~**Form the cluster**: Create cluster on pve1, join pve2 and pve3~~ ✓ Done 2026-04-10 — cluster formed; no HA configured; no production workloads yet
2. ~~**Shared storage**: Expose Pegasus DAS from Mac Mini #1 via NFS; mount on all Proxmox nodes~~ ✓ Done 2026-04-10 — LittlePeggy and BigPeggy NFS-mounted on all nodes; Proxmox storage IDs `littlepeggy` and `bigpeggy`; see inventory/README.md for paths

## Track T2 — Core service platform on the Proxmox cluster (after T1)

Goal: use the three Proxmox nodes as the main service platform, with clear role separation and private access via Tailscale + DNS + reverse proxy.

### Confirmed node roles

- **pve1** = front door / network core
  - AdGuard Home or Pi-hole
  - Nginx Proxy Manager
  - dashboard homepage (Homepage/Glance/Homarr — choose one)
- **pve2** = media-support app node
  - Sonarr
  - Radarr
  - Prowlarr
  - Overseerr
  - Audiobookshelf
  - Calibre-Web
- **pve3** = ops / automation / document node
  - Uptime Kuma
  - Prometheus
  - Grafana
  - alerting
  - n8n
  - Paperless-ngx
  - Portainer

### Phase 1 — establish the front door on pve1

1. ~~Choose DNS stack: AdGuard Home or Pi-hole~~ ✓ AdGuard Home
2. ~~Choose dashboard: Homepage, Glance, or Homarr~~ ✓ Homepage (may revisit Homarr later)
3. ~~**Deploy AdGuard Home LXC on pve1**~~ ✓ Done 2026-04-13 — CT110, `10.27.27.110`, active
4. ~~**Deploy Nginx Proxy Manager LXC on pve1**~~ ✓ Done 2026-04-13 — CT101, `10.27.27.111`, active
5. Deploy Homepage LXC on pve1 — see `lxc/pve1/homepage/README.md` (CT102, `10.27.27.112`)
6. ~~**Configure AdGuard Home DNS rewrites**~~ ✓ In progress — individual entries per service → `10.27.27.111`; Jellyfin done; see `lxc/pve1/dns-proxy-entries.md` for full list
7. ~~**Update router DNS** from Pi-hole (`10.27.27.193`) to AdGuard Home (`10.27.27.110`)~~ ✓ Done 2026-04-13
8. Add proxy hosts in NPM for each service — ⚠️ In progress; Jellyfin done; see `lxc/pve1/dns-proxy-entries.md`

### Phase 2 — private DNS and Tailscale behavior

1. ~~**Keep Tailscale as the private remote-access layer**~~ ✓ Active
2. ~~**Configure DNS so service names under `chaseworkslab.com` resolve privately on LAN/tailnet**~~ ✓ Done 2026-04-13 — AdGuard Home DNS rewrites active
3. ~~**Split-DNS behavior for `chaseworkslab.com`**~~ ✓ Done 2026-04-13 — pve1 is Tailscale subnet router; `chaseworkslab.com` resolves on tailnet
4. Keep services non-public by default

### Phase 3 — monitoring and visibility on pve3

1. Deploy Uptime Kuma on pve3
2. Deploy Prometheus on pve3
3. Deploy Grafana on pve3
4. Add basic node/service checks for MM1, pve1, pve2, pve3, and CK10
5. Add basic alerts for service downtime and node reachability

### Phase 4 — application stack on pve2

1. Decide grouped Docker LXC vs separate LXCs for the arr stack
2. Deploy Sonarr/Radarr/Prowlarr/Overseerr on pve2
3. Deploy Audiobookshelf on pve2
4. Deploy Calibre-Web on pve2
5. Validate pathing to MM1 storage and qBittorrent integration

### Phase 5 — automation and document tools on pve3

1. Deploy n8n on pve3
2. Deploy Paperless-ngx on pve3
3. Deploy Portainer on pve3
4. Validate OCR/import flow and backup/export methods for key services

### Phase 6 — migrate nonessential services off MM1

1. Move Pi-hole function to pve1
2. Move Uptime Kuma to pve3
3. Migrate arr stack off MM1 only after storage paths and qBittorrent integration are verified
4. Keep MM1 focused on DAS/NFS/SMB + qBittorrent

### Notes

- Use the reverse proxy as the stable front door so backend services can move later without changing URLs
- Security model: tailnet access first, then service authentication
- Do not overload pve1 with heavy or noisy workloads
- Keep local LLM/OCR-heavy ambitions off the Mac mini cluster early; move them to the HP later
- Do not chase fake HA complexity on this hardware; prioritize backups and clean recovery

## Track T3 — Commit Docker Compose files and migrate services (after T1)

### Workflow note

- Prefer authoring compose files and playbooks locally, committing them to this repo, and then deploying to hosts
- Avoid adding extra browser-IDE layers on top of VM + Docker unless there is a very specific reason

### Step 1: Get compose files into git (do this first, before Proxmox migration)

1. Establish a clean repo structure for homelab authoring, likely centered around top-level `ansible/`, `docker/`, `scripts/`, and `docs/`
2. Treat this repo as the canonical home for deployment definitions and operational notes
3. Keep real secrets out of git; use `.env.example` files for committed examples

### Existing migration tasks

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
