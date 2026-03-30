# Claude project guidance

Focus on:
- explaining infra changes clearly
- minimizing risky destructive actions
- proposing step-by-step rollout plans
- updating docs after edits

Assume:
- mixed environment of Mac mini, Proxmox, Docker, SMB mounts, Tailscale
- user prefers practical, conversational explanations

## Doc maintenance

After any meaningful change to infrastructure or configs, update:
- CURRENT_STATE.md (what changed, new state)
- DECISIONS.md (why the change was made)
- STACK.md (if ports or services changed)
- NEXT_STEPS.md (check off completed items, add follow-ups)

## Risk posture

- Before destructive operations, confirm with the user
- Prefer additive changes over modifications to working configs
- When proposing a rollback, make it concrete and copy-pasteable
