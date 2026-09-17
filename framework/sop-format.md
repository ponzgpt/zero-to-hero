# SOP Format

**Normative.** `zth check` enforces this. A file under `sops/` that does not conform is not a SOP.

## File

One SOP per file, at `sops/<slug>.md`. The slug names the done-state, not the topic:
`install-on-consumer-hardware.md`, not `proxmox.md`.

## Frontmatter

YAML, first thing in the file, delimited by `---`.

```yaml
---
zth: 1
title: Install Proxmox VE on consumer hardware
goal: From bare metal to a Proxmox host reachable at https://<ip>:8006 with a non-root admin user.
done_when:
  - "`pveversion` prints 8.x"
  - "Web UI answers on :8006 from another host on the LAN"
  - "`sudo -u admin pvesh get /nodes` succeeds"
route: Official ISO installer + manual post-install hardening
verified:
  on: 2026-09-17
  by: ponzgpt
  env: Intel N100, 16 GB RAM, Proxmox VE 8.2.4
recheck_every: 90d
---
```

| Key | Required | Meaning |
|---|---|---|
| `zth` | yes | Format version. Currently `1`. |
| `title` | yes | Imperative, names the done-state. |
| `goal` | yes | One sentence, from FRAME. |
| `done_when` | yes | 2–5 assertions, each true or false on a real machine. |
| `route` | yes | The route chosen in ROUTE, in a few words. |
| `verified.on` | yes | `YYYY-MM-DD`. Last date the whole path was **executed**, not read. |
| `verified.by` | yes | Who executed it. |
| `verified.env` | yes | Where. Hardware, OS, versions. The SOP is only claimed true here. |
| `recheck_every` | yes | `<n>d`. Drift clock, set from the fastest-moving dependency. |
| `pins` | no | Versions, URLs or facts known to rot. Read during re-verification. |
| `status` | no | `draft` while the path has not been executed end to end. Omit once it has. |

## Required sections

Exactly these five `##` headings, in this order. Extra `###` subsections are fine.

### `## Context`

Who this is for, what it assumes they have, and what it deliberately does not cover. Under a
screenful.

### `## The path`

The numbered happy route. One action per step. Each step carries the command or the action, and
what you should see when it worked — the check is what makes a step verifiable rather than
hopeful.

```markdown
3. Install the package.

   ```bash
   sudo apt install -y proxmox-ve
   ```

   Ends with `Setting up proxmox-ve (8.2.0)`. Takes ~4 min on a cold cache.
```

No branching. If the path forks on a real decision, state the decision in one line, give the
default, and send the other branch to `Routes not taken` — or split the SOP.

### `## Traps`

Every wall hit during RUN. One `###` per trap: the symptom **verbatim** (the exact error string
someone will paste into a search box), the cause, the escape.

An empty `Traps` section on a non-trivial SOP means the path was not really executed.

### `## Routes not taken`

Every rejected candidate, one line of what it was and one of why it lost — in the vocabulary of
the ROUTE rubric (steps, prerequisites, blast radius, reversibility, staleness). This section
exists so nobody re-litigates the decision, including you in a year.

### `## Keep fresh`

What is expected to rot, and what re-verification means here. Name the specific things — a version
that will bump, a URL that will move, a default that will change — so the next run knows where to
look first.

## Conventions

- **Commands are copy-pasteable.** No `$` prompt, no interleaved output inside the fence.
- **Placeholders are `<angle-bracketed>`** and every one is defined at first use.
- **Every claim about behaviour is something you observed**, not something you expect. If you did
  not see it, do not write it.
