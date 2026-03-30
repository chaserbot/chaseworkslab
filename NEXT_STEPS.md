# Next steps

Planned work, in-progress tasks, and ideas backlog.
Check off items as they are completed. Move finished items to DECISIONS.md.

## In progress

<!-- Tasks actively being worked on -->

## Planned

<!-- Upcoming work with rough priority order -->

## Backlog / ideas

<!-- Lower-priority items or ideas not yet scheduled -->

---

## Deferred tasks from monorepo migration

### 1. Audit and update internal path references in each subfolder

After migration from standalone repos to this monorepo, some scripts and docs
may still reference the old file structure or standalone clone paths.

Known example: the Proxmox post-install script broke previously due to
assumed file paths that no longer matched reality. Each subfolder needs a
pass to:
- Update any hardcoded paths (e.g. ~/chaseworkslab-proxmox -> ~/chaseworkslab/proxmox)
- Update clone URLs if scripts reference the old per-repo GitHub URLs
- Fix any relative path assumptions in shell scripts

Priority: high — do this before relying on any subfolder script in production.

### 2. Add copy-paste quick-start sections to each subfolder README

Each subfolder's README.md should have a prominent "Getting Started" section
near the top with copy-paste install/clone commands — the same way a
well-maintained open-source tool presents its installation instructions.

Users should not need to read raw script code to find the relevant
curl command or install invocation.

Template structure for each subfolder README:

    ## Quick start

    Clone the monorepo (if you haven't already):

        git clone https://github.com/chaserbot/chaseworkslab.git ~/chaseworkslab

    Then run the install/setup script:

        cd ~/chaseworkslab/<subfolder>
        bash <install-script>.sh

Priority: medium — improves usability on new machines.
