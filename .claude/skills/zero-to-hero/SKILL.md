---
name: zero-to-hero
description: Create or re-verify a SOP in a Zero to Hero repo. Use when asked to write, extend, or refresh a guide, runbook or SOP here, when `zth drift` reports a stale SOP, or when starting a new topic from zero. Drives the FRAME-SCOUT-ROUTE-RUN-FORGE-KEEP loop.
---

# Zero to Hero

Read `.zth/method.md` (normative) and `.zth/sop-format.md` (output contract) first. Then work the
loop. Do not skip phases; each one produces an input the next one needs.

## New SOP

1. **FRAME** — Write `goal` and `done_when` before anything else. Show them to the user and get
   agreement. If you cannot phrase `done_when` as machine-checkable assertions, the topic is too
   broad — narrow it and ask again.
2. **SCOUT** — Gather primary sources, then dated field reports, then consensus. Record versions
   and dates. Stop when new sources stop changing the candidate list.
3. **ROUTE** — Score every candidate on the five axes in `.zth/method.md`. Show the user the table
   and your pick before you execute anything.
4. **RUN** — Execute the chosen route on a real system, from as close to zero as possible. Capture
   commands and output verbatim to a scratch transcript. Record every wall you hit.
   **If you cannot execute it, stop and tell the user.** Do not write the SOP from inference —
   that breaks rule 1 of the method and is the failure this framework exists to prevent.
   When the route turns out to be wrong, return to ROUTE rather than patching around it.
5. **FORGE** — Compile the transcript into `sops/<slug>.md` from `.zth/templates/SOP.md`. The path
   is the route as it would go *now*, not as it went. Walls become `Traps`, verbatim symptoms
   included. Rejections become `Routes not taken`.
6. **KEEP** — Set `verified` and `recheck_every` from the fastest-moving dependency. Name the
   specific things expected to rot in `Keep fresh`. Add the SOP to the table in `README.md`.

Finish with `.zth/bin/zth check` and `.zth/bin/zth drift`.

## Re-verifying a stale SOP

Drift means **RUN again**, not re-read.

1. Execute the existing path top to bottom on a current system.
2. Every divergence from what the SOP claims is a change: fix the step, or move it to `Traps` if
   it now fails in a way readers will hit.
3. Re-check `pins` and the items listed under `Keep fresh` specifically.
4. If the route itself is dead (deprecated tool, removed package), go back to SCOUT and ROUTE.
   Move the old route to `Routes not taken` with what killed it.
5. Update `verified.on`, `verified.by`, `verified.env` — **only** after the run. An unchanged SOP
   still earns a new date, because the re-run is the work.
