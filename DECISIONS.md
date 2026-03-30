# Decisions

Architectural decision log. Add an entry whenever a meaningful infrastructure
or configuration decision is made. Entries are most recent first.

Format:

    ## YYYY-MM-DD: Short title
    **Decision:** What was decided.
    **Why:** Rationale, alternatives considered.
    **Rollback:** How to undo if needed.

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
