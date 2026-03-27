# Context — Proxmox Cluster

Supports: `chaserbot/chaseworkslab-proxmox`

---

## Goal

3-node Proxmox VE cluster on Mac Mini A1347 (late 2014) hardware.
Shared storage via Pegasus DAS hosted on Mac Mini #4 (stays on macOS).
Scripts are public and curl-friendly for clean rebuilds.

---

## Hardware

| Node | Hostname | IP | Status |
|------|----------|----|--------|
| Mac Mini #1 | pve1 | TBD | ⬜ Install pending |
| Mac Mini #2 | pve2 | TBD | ⬜ Install pending |
| Mac Mini #3 | pve3 | TBD | ⬜ Install pending |
| Mac Mini #4 | — | 10.27.27.22 | ✅ macOS, stays — Pegasus DAS via Thunderbolt |

All 3 nodes are identical hardware. A script that works on one works on all.

**Network:** 10.27.27.0/24
**Router:** 10.27.27.1 (Luxul ABR-5000)
**Switch:** 10.27.27.3 (Luxul XMX-1010P)

---

## Repo Structure

```
chaseworkslab-proxmox/
├── CLAUDE.md
├── README.md
├── install/
│   ├── node-setup.sh       ← runs on each node post-install
│   └── cluster-init.sh     ← run once on node 1 to create cluster
├── config/
└── docs/
    └── mac-mini-notes.md   ← A1347 hardware quirks
```

---

## Progress

- [x] Repo created
- [x] Install script started
- [ ] `node-setup.sh` complete and tested
- [ ] `cluster-init.sh` drafted
- [ ] Tested on at least one Mac Mini
- [ ] Static IPs assigned to all 3 nodes
- [ ] Cluster created: `pvecm create chaseworkslab`
- [ ] Nodes 2 and 3 joined
- [ ] Pegasus DAS shares mounted on cluster

---

## Known Mac Mini A1347 Quirks

- May need `nomodeset` kernel param if display is blank during install
- No Thunderbolt passthrough to Proxmox — that's why Mini #4 stays on macOS
- All 3 units identical — treat them as interchangeable

---

## Conventions

- Bash scripts, idempotent where possible
- Variables at the top — no hardcoded IPs or hostnames in logic
- Comments explain *why*, not just *what*
- Target curl pattern:
  ```bash
  bash <(curl -s https://raw.githubusercontent.com/chaserbot/chaseworkslab-proxmox/main/install/node-setup.sh)
  ```

---

## Last Session

> Session date: 2026-03-26
> Was building the install script. Switched to Claude Code to work on GitHub
> commits and file structure. Context files now live in homelab-context (private).
> Next: pick up node-setup.sh and get it to a testable state.

---

## How to Start a Session

```
Read proxmox.md in my homelab-context repo and let's pick up the install script.
```
