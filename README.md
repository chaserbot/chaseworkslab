# chaseworkslab

Monorepo for all chaserbot homelab infrastructure, configs, and tooling.

## Structure

| Folder | Source Repo | Description |
|--------|-------------|-------------|
| dotfiles/ | chaseworkslab-dotfiles | Terminal config — zsh, Oh My Zsh, Powerlevel10k, bash |
| llm/ | chaseworkslab-llm | Self-hosted LLM stack (Ollama, Open WebUI, etc.) |
| docker/ | chaseworkslab-docker | Docker Compose stacks for homelab services |
| ansible/ | chaseworkslab-ansible | Ansible playbooks for provisioning and config management |
| proxmox/ | chaseworkslab-proxmox | Proxmox host configuration, docs, and post-install scripts |
| arr/ | chaseworkslab-arr | Arr stack configs and compose files (Sonarr, Radarr, Prowlarr, etc.) |
| monitoring/ | chaseworkslab-monitoring | Grafana and Prometheus monitoring stack |
| lxc/ | chaseworkslab-lxc | LXC container templates and configs for Proxmox |
| inventory/ | chaseworkslab-inventory | Homelab network inventory — hosts, IPs, services, ports |
| homelab-context/ | homelab-context | Homelab context and reference documentation |

## Git history

All commit history from each source repository has been preserved.
To inspect history for a specific subfolder:

    git log --oneline -- dotfiles/
    git log --oneline -- ansible/
    git log --follow -- proxmox/post-install.sh

## Quick start on a new machine

    git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab

Then navigate to whichever subfolder you need and follow its README.

## Context files for AI tools

This repo includes a set of context and memory files designed to onboard any LLM
without requiring it to scan the full codebase from scratch:

| File | Purpose |
|------|---------|
| AGENTS.md | Project rules and behavioral guidelines for AI agents |
| CLAUDE.md | Claude-specific guidance and environment assumptions |
| STACK.md | Full service, port, and tool inventory |
| CURRENT_STATE.md | What is running, what is stable, last-known-good state |
| NEXT_STEPS.md | Planned work, in-progress tasks, and ideas backlog |
| DECISIONS.md | Architectural decision log |

## Migrations

This monorepo was created using `scripts/create-monorepo.sh` from
[chaseworkslab-dotfiles](https://github.com/chaserbot/chaseworkslab-dotfiles).
