# LLM Stack — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Self-hosted LLM infrastructure — Ollama for model serving, Open WebUI for a chat interface. Planned but not yet deployed. Will serve as the backbone for FATFISH (the Fatfish event production AI assistant) as well as personal/homelab automation via n8n.

## Current State
- **Not yet deployed**
- Repo scaffolded: `github.com/chaserbot/chaseworkslab-llm`
- Architecture being designed as part of FATFISH (Track T5)

## Planned Stack

| Tool | Role |
|---|---|
| Ollama | Local model runner — serves LLM inference API |
| Open WebUI | Chat UI frontend, connects to Ollama |
| n8n | Automation / agent orchestration layer |
| LiteLLM (optional) | Unified API proxy — route to Ollama or cloud LLMs |

## Planned Host
- GPU would be ideal — Mac Minis (A1347) are CPU-only, no dGPU
- Best candidate: Proxmox LXC or VM with CPU inference
- May run on a separate machine if GPU is added later
- Ace Magician CK10 (i7-1081U) is an option for CPU inference — spare compute

## FATFISH Connection
The LLM stack is the core of FATFISH — a self-hosted AI assistant for Fatfish (Chase's event production company). Intended capabilities:
- Quoting assistance (job costing, proposal generation)
- Client nurturing (follow-up drafts, communication templates)
- Team communication workflows
- Integration with n8n for automation pipelines

FATFISH repo: `github.com/chaserbot/ff-assistant-starter` (private, early stage)

## Related GitHub Repo
`github.com/chaserbot/chaseworkslab-llm`

Planned structure:
```
chaseworkslab-llm/
  docker-compose.yml     ← Ollama + Open WebUI
  .env.example
  models/
    README.md            ← document which models to pull
  README.md
```

## Next Steps
1. Decide on host machine for LLM inference
2. Deploy Ollama + Open WebUI via Docker Compose
3. Pull initial models (llama3, mistral, etc.) and test
4. Connect Open WebUI to Ollama
5. Wire Ollama API into n8n for FATFISH prototype
6. Commit compose files to `chaseworkslab-llm`
