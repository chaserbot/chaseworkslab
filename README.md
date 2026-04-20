# chaseworkslab

Monorepo for all chaserbot homelab infrastructure, configs, and tooling.

Current working direction: author infrastructure locally in VS Code, keep GitHub as the source of truth, and deploy intentionally to hosts rather than building directly on them.

## Structure

| Folder | Description |
| ------ | ----------- |
| dotfiles/ | Terminal config — zsh, Oh My Zsh, Powerlevel10k, bash |
| llm/ | Self-hosted LLM stack (Ollama, Open WebUI, etc.) |
| docker/ | Docker Compose stacks for homelab services |
| ansible/ | Ansible playbooks for provisioning and config management |
| proxmox/ | Proxmox host configuration, docs, and post-install scripts |
| arr/ | Arr stack configs and compose files (Sonarr, Radarr, Prowlarr, etc.) |
| monitoring/ | Grafana and Prometheus monitoring stack |
| lxc/ | LXC provisioning READMEs for each service on the Proxmox cluster |
| inventory/ | Homelab network inventory — hosts, IPs, services, ports |

## Working style

- Primary authoring happens locally, not in a browser IDE running on a homelab host
- GitHub is the canonical home for compose files, Ansible playbooks, scripts, and docs
- Hosts should pull or receive deployment artifacts intentionally, rather than being treated as the main editing environment
- Git-tracked `.env.example` files are preferred over committing real secrets

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
without requiring it to scan the full codebase from scratch.

Recommended read order for other AI tools:
1. `README.md`
2. `AGENTS.md`
3. `AGENT_ROUTING.md`
4. `CURRENT_STATE.md`
5. `NEXT_STEPS.md`
6. `DECISIONS.md`
7. `STACK.md`
8. `CLAUDE.md` if the tool supports or benefits from Claude-specific notes

Important continuity note:
- broader assistant memory, identity, and migration context live outside this repo in the OpenClaw workspace and backup repo
- primary OpenClaw workspace path: `/home/chaseworkslab/.openclaw/workspace`
- backup repo: `https://github.com/chaserbot/openclaw-backup`
- if an AI tool is helping with ongoing homelab work, it should prefer repo docs for infrastructure truth and use the OpenClaw workspace/backup only for assistant continuity, prior notes, and migration context

| File | Purpose |
|------|---------|
| AGENTS.md | Project rules and behavioral guidelines for AI agents |
| AGENT_ROUTING.md | Task-routing and model-selection guidance |
| CLAUDE.md | Claude-specific guidance and environment assumptions |
| STACK.md | Full service, port, and tool inventory |
| CURRENT_STATE.md | What is running, what is stable, last-known-good state |
| NEXT_STEPS.md | Planned work, in-progress tasks, and ideas backlog |
| DECISIONS.md | Architectural decision log |

## Migration

This monorepo was created using `scripts/create-monorepo.sh` from
[chaseworkslab-dotfiles](https://github.com/chaserbot/chaseworkslab-dotfiles).
