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

## Docker standards

All services use Docker Compose — no standalone `docker run` commands. Each service stack:
- Gets its own directory with a `docker-compose.yml` and `.env.example`
- Secrets via `.env` files (gitignored); `.env.example` committed with placeholder values only
- App config directories are gitignored — they contain API keys, tokens, and generated databases

Standard `.gitignore` pattern for all Docker service folders:

```gitignore
# Credentials
*.env
.env*
secrets/

# App config dirs (contain API keys, tokens)
*/config/
config/

# Generated databases
*.db
*.db-wal
*.db-shm
*.sqlite

# Logs
*.log
logs/
*/logs/
```

## Working with secrets

Use environment variables or `.env` files (gitignored) for all credentials.
Reference `.env.example` files for required variable names without values.
Never commit `.env`, API keys, passwords, or tokens.

## Branching

Work in feature branches. Keep `main` stable and deployable.
