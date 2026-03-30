# Stack

Complete inventory of services, tools, and ports running in the homelab.
Update this file whenever a service is added, removed, or its port changes.

## Infrastructure

| Component | Role | Notes |
|-----------|------|-------|
| Mac mini | Primary workstation / media server | macOS |
| Proxmox node(s) | Hypervisor | See proxmox/ subfolder |
| Tailscale | VPN / zero-trust networking | Connects all nodes |
| SMB | File sharing | Mounted on relevant hosts |

## Services and ports

| Service | Folder | Port(s) | Host | Notes |
|---------|--------|---------|------|-------|
| Open WebUI | llm/ | <!-- port --> | <!-- host --> | LLM frontend |
| Ollama | llm/ | <!-- port --> | <!-- host --> | Local LLM backend |
| Grafana | monitoring/ | <!-- port --> | <!-- host --> | Dashboards |
| Prometheus | monitoring/ | <!-- port --> | <!-- host --> | Metrics |
| Sonarr | arr/ | <!-- port --> | <!-- host --> | TV automation |
| Radarr | arr/ | <!-- port --> | <!-- host --> | Movie automation |
| Prowlarr | arr/ | <!-- port --> | <!-- host --> | Indexer management |
| <!-- service --> | docker/ | <!-- port --> | <!-- host --> | <!-- notes --> |

## Tools

| Tool | Purpose | Installed on |
|------|---------|-------------|
| Docker + Compose | Container runtime | Proxmox LXC / nodes |
| Ansible | Config management | Mac mini (control node) |
| fzf | Fuzzy finder | All machines (via dotfiles) |
| eza | ls replacement | All machines (via dotfiles) |
| Oh My Zsh + Powerlevel10k | Shell | macOS only (via dotfiles) |
