# Proxmox infrastructure

Proxmox host configuration and recovery documentation for chaseworkslab. For current IPs and service locations, use [`../inventory/README.md`](../inventory/README.md); this file focuses on the Proxmox hosts and bootstrap workflow.

---

## 🖥️ Hardware

| Device | Role | OS |
|---|---|---|
| Mac Mini #1 (A1347) — MM1 | NAS Brain / DAS host | macOS |
| Mac Mini #2 (A1347) — MM2 | Proxmox Node 1 — pve1 | Proxmox VE |
| Mac Mini #3 (A1347) — MM3 | Proxmox Node 2 — pve2 | Proxmox VE |
| Mac Mini #4 (A1347) — MM4 | Proxmox Node 3 — pve3 | Proxmox VE |
| LittlePeggy (Pegasus 2 R8) | DAS storage — Thunderbolt 2 to MM1 | — |
| BigPeggy (Pegasus 3 R8) | DAS storage — Thunderbolt 3 to MM1 (capped at TB2) | — |
| Ace Magician CK10 | Jellyfin (media server) | — |
| Intel NUC5i5RYK x2 | Spare / Batocera gaming | — |
| UniFi UX7 | Router / gateway | — |
| USW Flex 2.5G 8-port PoE | Core switch (rack) | — |
| USW Flex 2.5G Mini (4-port) | Desktop switch | — |
| USW Lite 8-port PoE | Server switch (MM1, pve1–3, CK10) | — |
| TP-Link EAP225 Outdoor | Outdoor access point | — |

> LittlePeggy and BigPeggy are Thunderbolt daisy-chained to MM1. MM1 shares both over NFS to all Proxmox nodes. See `proxmox/storage-setup.md` for full details.

---

## 🌐 Network

| Device | IP |
|---|---|
| Mac Mini #1 (macOS) | 10.27.27.22 |
| Mac Mini #2 (pve1) | 10.27.27.101 |
| Mac Mini #3 (pve2) | 10.27.27.102 |
| Mac Mini #4 (pve3) | 10.27.27.103 |

Internal domain: `chaseworkslab.com`

---

## Repository structure

```text
proxmox/
├── README.md
├── post-install.sh
├── cluster-setup.md
└── storage-setup.md
```

---

## 🚀 Standing Up a New Proxmox Node

1. Install Proxmox VE from USB (hold Option on boot to select USB on Mac Mini)
2. SSH into the new node
3. Run the post-install script:

Clone the monorepo and run the checked-in script:

```bash
git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab
cd ~/chaseworkslab
sudo bash proxmox/post-install.sh <node-number>
```

4. Reboot
5. Verify fan control: `systemctl status mbpfan`
6. Verify auto-boot service: `systemctl status mac-autoboot`
7. Verify NFS mounts: `df -h | grep mnt`
8. See `proxmox/cluster-setup.md` to join the cluster

---

## 📦 Services

| Service | Port | Host | Status |
|---|---|---|---|
| Jellyfin | 8096 | CK10 | ✅ Active |
| Audiobookshelf | 13378 | `10.27.27.112` | ✅ Active |
| Radarr | 7878 | docker-arr VM (`10.27.27.47`) | ✅ Active |
| Sonarr | 8989 | docker-arr VM (`10.27.27.47`) | ✅ Active |
| Prowlarr | 9696 | docker-arr VM (`10.27.27.47`) | ✅ Active |
| Seerr | 5055 | docker-arr VM (`10.27.27.47`) | ✅ Active |
| qBittorrent | 8080 | docker-arr VM (`10.27.27.47`) | ✅ Active via Gluetun |
| Paperless-ngx | 8000 (unconfirmed) | Unknown backend; inspect NPM | ⚠️ Investigate |
| Uptime Kuma | 3001 | pve1 CT119 (`10.27.27.119`) | ✅ Active |
| AdGuard Home | 53/80 | pve1 CT110 (`10.27.27.110`) | ✅ Active |
| Nginx Proxy Manager | 80/443/81 | pve1 CT101 (`10.27.27.111`) | ✅ HTTP active; HTTPS needs repair |
| Homepage | 3000 | pve1 CT112 (`10.27.27.112`) | ✅ Active |
| n8n | 5678 | Planned `10.27.27.133` | ⬜ Not deployed |

---

## 🔒 Secrets

Secrets are **never** committed to this repo. `.env` files, API keys, and passwords are excluded via `.gitignore`. Each service folder contains a `.env.example` file documenting which secrets are needed — fill in your own values and save as `.env` locally.

---

## 📋 Project Tracks

| Track | Description | Status |
|---|---|---|
| T1 | Physical & Cable Management | ✅ Done |
| T2 | Proxmox Cluster Setup | ✅ Cluster formed; no HA |
| T3 | Network, DNS & Remote Access | 🔧 HTTP/split DNS active; HTTPS cleanup pending |
| T4 | Service Migration & Distribution | 🔧 Arr and Uptime migrated; Paperless unresolved |
| T5 | n8n Automation | ⬜ Pending |
| T6 | FATFISH AI Assistant | 🧪 Design Phase |
| T7 | Reproducibility & GitHub | ♻️ Ongoing |
