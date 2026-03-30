# Project rules

- This repo manages Chase's homelab.
- Prefer Docker Compose for app services unless there is a strong reason otherwise.
- Proxmox hosts should be documented before changes are applied.
- Never hardcode secrets in yaml or shell scripts.
- When changing ports, also update STACK.md.
- After any meaningful change:
  1. update CURRENT_STATE.md
  2. add an entry to DECISIONS.md
  3. suggest rollback steps

## Repo structure

Each subfolder maps to what was previously a standalone GitHub repo.
See README.md for the full folder-to-repo mapping.

## Working with secrets

Use environment variables or `.env` files (gitignored) for all credentials.
Reference `.env.example` files for required variable names without values.
Never commit `.env`, API keys, passwords, or tokens.

## Branching

Work in feature branches. Keep `main` stable and deployable.
