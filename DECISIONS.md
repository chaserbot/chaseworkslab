# Decisions

Architectural decision log. Add an entry whenever a meaningful infrastructure
or configuration decision is made. Entries are most recent first.

Format:

    ## YYYY-MM-DD: Short title
    **Decision:** What was decided.
    **Why:** Rationale, alternatives considered.
    **Rollback:** How to undo if needed.

---

## 2026-04-10: Prefer local VS Code + GitHub over browser IDE inside the Docker VM

**Decision:** Scrapped the `code-server` direction for the Docker VM and standardized on local VS Code as the primary editing environment, GitHub as the source of truth, and GitHub Codespaces as an optional remote fallback.

**Why:** Running a browser IDE inside Docker inside a VM on Proxmox added unnecessary layers, permission friction, and operational clutter for this workflow. Local authoring plus Git-based deployment is simpler, easier to reason about, and better aligned with maintaining compose files, Ansible playbooks, scripts, and docs as durable infrastructure definitions.

**Rollback:** `code-server` or another remote editor can be reintroduced later if there is a concrete need for browser-based editing from multiple machines, but it should justify the added complexity.

## 2026-04-03: Role-based split for homelab hardware

**Decision:** Standardized the hardware roles as follows:
- MM1 stays a macOS storage/download bridge for Pegasus DAS, NFS/SMB exports, and qBittorrent
- CK10 stays a dedicated Jellyfin box
- the 3-node Proxmox Mac mini cluster becomes the main infrastructure/app platform
- the 2017 MacBook Pro is treated as a control surface/admin machine, not core infrastructure
- the two Intel NUCs are helper/sandbox/failover nodes, not primary production hosts
- the HP Envy Phoenix H9 becomes the future heavier experiment box once repaired

**Why:** This keeps each machine in a role that matches its strengths, avoids overloading the old Mac mini cluster with everything, and preserves the boxes that already do one job well.

**Rollback:** Individual services can be moved later if real-world load or maintenance pain proves the split wrong.

---

## 2026-04-03: Proxmox node role split by service behavior

**Decision:** Assigned the three Proxmox nodes distinct roles:
- **pve1** = front door / network core (DNS, reverse proxy, dashboard)
- **pve2** = media-support app node (arr stack, Overseerr, Audiobookshelf, Calibre-Web)
- **pve3** = ops / automation / documents (Uptime Kuma, Prometheus, Grafana, alerting, n8n, Paperless-ngx, Portainer)

**Why:** Critical infra should be separated from automation and app stacks. Related apps should stay together. The old dual-core Mac minis are better served by clear roles than by fake-perfect balancing.

**Rollback:** Services can be regrouped or moved later if one node becomes a hotspot or if grouped Docker/LXC patterns prove annoying in practice.

---

## 2026-04-03: Keep the Mac mini cluster focused on boring core infra; defer heavy AI workloads

**Decision:** The Mac mini Proxmox cluster is for lightweight/stable infrastructure, not serious local LLM inference or heavier experimental compute. Heavier AI/OCR/dev workloads should move to the HP Envy once repaired.

**Why:** The 2014 Mac minis are useful for DNS, reverse proxy, monitoring, automation, and support apps, but they are not good long-term hosts for local LLM ambitions or heavier OCR/coding workloads.

**Rollback:** Light experiments can still be tested on the cluster temporarily, but the default plan should keep them off the critical path.

---

## 2026-04-03: Use Nginx Proxy Manager as the first reverse proxy path

**Decision:** Use Nginx Proxy Manager as the initial reverse proxy solution instead of hand-built nginx/Caddy/Traefik complexity.

**Why:** It is the fastest practical path to human-readable service URLs, simple proxy management, and low-friction homelab operations.

**Rollback:** Proxy hosts can later be migrated to plain nginx, Caddy, or Traefik if the homelab grows beyond NPM’s comfort zone.

---

## 2026-04-03: Prefer backups and recovery over fake HA complexity

**Decision:** Treat this 3-node Mac mini Proxmox setup as a practical homelab cluster, not an enterprise HA environment. Prioritize backups, export/restore paths, and clean service separation over high-availability theater.

**Why:** The hardware is useful but modest. Overengineering HA on older dual-core minis would add complexity faster than it adds resilience.

**Rollback:** Real HA techniques can be layered in later if the hardware or operational needs justify it.

---

## 2026-03-30: Merge homelab-context into root docs; remove subfolder

**Decision:** Dissolved the `homelab-context/` subfolder and merged all per-tool context into
the root `.md` files (CURRENT_STATE.md, STACK.md, NEXT_STEPS.md, DECISIONS.md, AGENTS.md).

**Why:** Maintaining a separate context folder meant duplicating updates — any service change
required editing both the homelab-context file and the relevant root doc. Single source of truth
is easier to keep accurate.

**Rollback:** Content is preserved in git history under `homelab-context/`. To restore, `git checkout <hash> -- homelab-context/`.

---

## 2026-03-26: Docker Compose as standard deployment method

**Decision:** All homelab services use Docker Compose — no standalone `docker run` commands.
Each service stack gets its own directory with a `docker-compose.yml` and `.env.example`.
Secrets via gitignored `.env` files; app config directories gitignored.

**Why:** Makes services reproducible, portable, and version-controlled. Migration to a new host
means copying `docker-compose.yml`, updating volume paths, and running `docker compose up -d`.

**Rollback:** N/A — this is a convention. Individual services can be run without Compose if needed.

---

## 2026-03-26: Pi-hole on UTM VM (Mac Mini #1) as interim DNS

**Decision:** Pi-hole runs as a UTM virtual machine on Mac Mini #1 (`10.27.27.193`) as an
interim solution. Router pushes `10.27.27.193` as DNS to all DHCP clients.

**Why:** Fastest path to working ad blocking and local DNS. Proxmox cluster was not yet ready
for an LXC host.

**Rollback:** Update router DNS to `1.1.1.1` or another upstream resolver directly. Migration
to Proxmox LXC is planned (Track T2).

---

## 2026-03-26: Flat network on 10.27.27.0/24 with DHCP reservations

**Decision:** All homelab devices on a single flat `10.27.27.0/24` subnet with static IPs
managed via DHCP reservations on the Luxul ABR-5000.

**Why:** Simple to manage for a home network at current scale. VLANs add complexity without
clear benefit until the number of devices and security requirements justify it.

**Rollback:** No rollback needed — VLAN segmentation can be layered on top later without
disrupting existing IP assignments.

---

## 2026-03-26: Proxmox cluster on 2014 Mac Mini A1347s

**Decision:** Three 2014 Mac Mini A1347s repurposed as Proxmox VE nodes (pve1/pve2/pve3 at
`10.27.27.31-33`). Post-install script handles Mac Mini-specific thermal management (mbpfan,
applesmc, coretemp) and auto-boot service.

**Why:** Available hardware. Intel Core i5/i7 with 16GB RAM is sufficient for LXC containers
and lightweight VMs. No dGPU — LLM inference will be CPU-only.

**Rollback:** Nodes are independent. If cluster formation fails, each node remains a standalone
Proxmox host. Re-imaging from scratch is always an option.

---

## 2026-03-30: Consolidate all chaseworkslab repos into a monorepo

**Decision:** Merged 10 standalone GitHub repos into a single monorepo
() using  to preserve full commit history
per subfolder.

**Why:** Maintaining separate repos meant cloning each one individually on
every new machine. A monorepo allows a single  to get everything,
makes cross-repo changes atomic, and simplifies context loading for AI tools.

**Repos merged:** chaseworkslab-dotfiles, chaseworkslab-llm, chaseworkslab-docker,
chaseworkslab-ansible, chaseworkslab-proxmox, chaseworkslab-arr,
chaseworkslab-monitoring, chaseworkslab-lxc, chaseworkslab-inventory, homelab-context.

**Rollback:** Each source repo is still intact on GitHub and was not deleted.
To revert to standalone workflow, simply clone the individual repos again.
The monorepo can be abandoned without any data loss.
