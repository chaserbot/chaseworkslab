# Decisions

Architectural decision log. Add an entry whenever a meaningful infrastructure
or configuration decision is made. Entries are most recent first.

Format:

    ## YYYY-MM-DD: Short title
    **Decision:** What was decided.
    **Why:** Rationale, alternatives considered.
    **Rollback:** How to undo if needed.

---

## 2026-03-30: Consolidate all chaseworkslab repos into a monorepo

**Decision:** Merged 10 standalone GitHub repos into a single monorepo
() using  to preserve full commit history
per subfolder.

**Why:** Maintaining separate repos meant cloning each one individually on
every new machine. A monorepo allows a single  to get everything,
makes cross-repo changes atomic, and simplifies context loading for AI tools.

**Repos merged:** chaseworkslab-dotfiles, chaseworkslab-llm, chaseworkslab-docker,
chaseworkslab-ansible, chaseworkslab-proxmox, chaseworkslab-arr,
chaseworkslab-monitoring, chaseworkslab-lxc, chaseworkslab-inventory, homelab-context.

**Rollback:** Each source repo is still intact on GitHub and was not deleted.
To revert to standalone workflow, simply clone the individual repos again.
The monorepo can be abandoned without any data loss.
