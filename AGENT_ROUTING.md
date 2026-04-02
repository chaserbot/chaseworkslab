# Agent routing

This file defines how assistant/model work should be distributed for this repo and related homelab operations.

## Goal

Use the simplest lane that fits the task, but deliberately split work when that improves quality, safety, or speed.

Primary lanes:
- **General**
- **Research**
- **Code**
- **Ops**

## Lane definitions

### General
Use for:
- normal conversation
- quick planning
- reminders
- short summaries
- small documentation edits
- one- or two-file changes that do not require broad repo exploration

Default model behavior:
- use the current default main model
- do not delegate tiny or routine tasks

### Research
Use for:
- tool comparisons
- architecture tradeoff analysis
- current best practices
- multi-source synthesis
- web-grounded recommendations
- tasks where choosing the right approach matters more than immediate execution

Default model behavior:
- prefer **Gemini** for broad web-grounded synthesis unless another model is clearly better for the task

Expected output:
- recommendation
- tradeoffs
- suggested next action

### Code
Use for:
- config generation
- script writing
- multi-file repo edits
- refactors
- debugging
- implementation work that requires repo exploration
- Docker Compose, Caddy, Prometheus, Grafana, Ansible, or other config authoring

Default model behavior:
- prefer **Codex** by default
- use Claude Code when explicitly requested or when it is clearly the better fit

### Ops
Use for:
- Proxmox
- DNS
- Tailscale
- SSH
- reverse proxies
- auth
- networking
- service exposure
- host configuration
- security-sensitive infrastructure work

Default model behavior:
- read-only first
- cautious by default
- prefer stronger reasoning or a separate session when risk is higher

## Practical routing rules

- Stay in the main session for small, obvious, low-risk tasks
- If a task is likely to take more than ~10–15 minutes, consider a specialized sub-session
- If external research quality matters more than direct execution, use the **Research** lane
- If implementation is bigger than a couple of direct edits, use the **Code** lane
- If the work could break access or expose services, treat it as **Ops** and ask before making live changes
- For mixed tasks, split them by phase:
  1. **Research** to compare and decide
  2. **Code** to build configs/scripts/docs
  3. **Ops** to deploy or validate safely

## Homelab-specific examples

### Monitoring stack
- Compare options (Prometheus/Grafana vs Netdata vs others) -> **Research**
- Generate configs/compose files/dashboards -> **Code**
- Deploy on Proxmox and validate exposure/access -> **Ops**

### DNS / Tailscale / reverse proxy
- Architecture and best-practice comparison -> **Research**
- Caddy/Nginx config creation -> **Code**
- Live rollout, certificates, and exposure review -> **Ops**

### Repo maintenance
- Small markdown/doc updates -> **General**
- Multi-file cleanup/refactor/path fixes -> **Code**

### LLM / automation stack
- Compare model/runtime options -> **Research**
- Build Compose files, scripts, workflows -> **Code**
- Host placement, auth, networking, and reliability -> **Ops**

## Biases / preferences

- Manual-first, auto-suggested delegation
- Suggest delegation when it clearly helps
- Do not delegate tiny tasks just for the sake of using another model
- Prefer stable, boring infrastructure choices over clever ones
- For homelab infrastructure, optimize for maintainability and recoverability, not novelty
