---
zth: 1
title: <Imperative sentence naming the done-state>
goal: <One sentence. Where the reader starts, where they end.>
done_when:
  - "<Assertion that is true or false on a real machine>"
  - "<Another one>"
route: <The route you chose, in a few words>
verified:
  on: <YYYY-MM-DD>
  by: <who executed it>
  env: <hardware, OS, versions>
recheck_every: 90d
status: draft
---

## Context

<Who this is for. What it assumes they already have. What it deliberately does not cover.>

## The path

1. <One action.>

   ```bash
   <command>
   ```

   <What you see when it worked.>

2. <Next action.>

## Traps

### <Verbatim symptom — the exact string someone would search for>

**Cause.** <Why it happens.>

**Escape.** <What fixes it.>

## Routes not taken

- **<Rejected route>** — <why it lost, in rubric terms: steps / prerequisites / blast radius / reversibility / staleness>.

## Keep fresh

- <Specific thing expected to rot, and where to look.>
- Re-verification = <executing which part, on what>.
