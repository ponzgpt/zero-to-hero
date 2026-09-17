# The Zero to Hero Method

**Normative.** An agent or a human following this document produces a SOP that conforms to
[`sop-format.md`](sop-format.md). Words in `CAPS` name a phase.

## What this is for

Given a topic, a piece of software, or an open question, produce **one document that gets a
competent-but-new person from zero to working**, by the path of least resistance — and keep that
document true as the world moves under it.

It is not a tutorial generator. The output is a SOP: a procedure someone can execute, that was
itself executed at least once, with the dead ends already removed.

## The three rules

1. **No step ships unexecuted.** Every command in a SOP was run by a human or an agent on a real
   machine, and the observed output is what the SOP claims. A step you believe should work is a
   hypothesis, not a step.
2. **The rejected routes are half the product.** A guide that only shows the winning path invites
   the reader to re-litigate it. Write down what you did not choose and why, so nobody pays that
   cost twice.
3. **A SOP without a freshness contract is a lie with a timestamp.** Every SOP declares when it was
   last verified and how long that verification is good for. Past that, it is stale until re-run.

## The loop

Six phases. FRAME through FORGE run once to birth a SOP. KEEP runs forever and sends you back to
RUN when it fires.

```
FRAME → SCOUT → ROUTE → RUN → FORGE → KEEP
                          ↑              │
                          └──────────────┘
```

---

### 0. FRAME — define "hero" as something you can test

The failure mode of every guide is a fuzzy destination. Before anything else, write the exit
criteria as statements that are true or false on a real machine.

**Produce:** `goal` (one sentence) and `done_when` (2–5 testable assertions).

- Bad: "Understand Proxmox."
- Good: "`pveversion` prints 8.x, and the web UI answers on :8006 from another host on the LAN."

If you cannot write `done_when`, you do not yet know what you are asking for. Stop and narrow the
topic until you can. A SOP with a fuzzy done-state cannot be verified, and therefore cannot be
kept fresh — it fails rule 3 before it is written.

**For learning topics** (where "done" is knowledge, not a running system), the assertion is a task
you can perform unaided: "I can write a systemd unit that restarts on failure, from memory, and
explain what `Restart=on-failure` excludes." Knowledge you cannot demonstrate is not a done-state.

---

### 1. SCOUT — map the terrain before you pick a line through it

Gather what exists. Breadth now buys you a shorter path later.

**Produce:** a working set of sources, the candidate routes, and the known traps.

Collect, in this order of trust:

1. **Primary** — official docs, source code, release notes, the `--help` output.
2. **Field reports** — issues, forum threads, blog posts *with dates*. These tell you where the
   official docs lie by omission.
3. **Consensus** — what most people actually do. Popularity is evidence about friction, not about
   correctness. Treat it as a signal that a path is well-trodden, not that it is right.

Record the **version and date** of everything. A field report from 3 years ago about a tool on a
6-week release cycle is archaeology, not evidence.

Stop scouting when new sources stop changing your candidate list. That moment usually arrives
sooner than it feels like it should.

---

### 2. ROUTE — choose the path of least resistance, on the record

Least resistance is **not** fewest steps. It is the lowest total cost to reach the done-state
*including the cost of the failures you will have along the way*. A three-command path that fails
silently and takes an afternoon to debug is more resistant than a ten-command path that fails
loudly at step four.

**Produce:** the chosen route, and every rejected route with its reason.

Score each candidate on five axes. Low is good.

| Axis | Question | 1 | 3 | 5 |
|---|---|---|---|---|
| **Steps** | Discrete actions to done-state | ≤5 | ~15 | 40+ |
| **Prerequisites** | What must you already have or learn first | nothing | one known tool | a new mental model |
| **Blast radius** | What breaks if this goes wrong | a container | a service | the host / your data |
| **Reversibility** | Cost to undo | one command | manual cleanup | reinstall |
| **Staleness risk** | How fast this route rots | stable/official | active project | a blog post's shell script |

Sum the five. Lowest total wins.

**Tiebreak, in order:**

1. **Loudest failure.** Between two equal routes, take the one that fails fast and obviously. A
   path that breaks at step 2 with a clear error beats one that appears to work and is wrong.
2. **Cheapest escape.** Prefer the route that is easiest to abandon for another one later.
3. **Fewest owners.** A route depending on one maintainer's script is more fragile than one
   depending on a distro package, regardless of how clean the script is.

**Never** pick a route you cannot execute yourself in RUN. An unexecutable route scores infinity;
it violates rule 1.

Write the rejections down *now*, while the reasons are in your head. In FORGE they become the
`Routes not taken` section, and by then you will have forgotten why you dropped the second-best
option.

---

### 3. RUN — execute the chosen route for real, and capture everything

This is the phase that separates a SOP from content. Take the route and walk it on a real system,
from a state as close to zero as you can manage (fresh VM, clean container, new account).

**Produce:** a raw transcript — every command, its real output, every wrong turn, every error, and
what actually resolved it.

Rules for the walk:

- **Capture verbatim.** Do not clean up as you go; you will smooth over the exact error string
  someone will later paste into a search engine. That string is valuable.
- **When you hit a wall, record the wall.** The failures you hit are the `Traps` section. A guide
  whose author hit no problems either had a trivial task or is not telling you something.
- **When the route turns out to be wrong, go back to ROUTE.** Do not patch a bad route into a
  working one with six workarounds. Re-score with what you now know and pick again. Record the
  route you abandoned and what killed it — that is the highest-value rejection you will write.
- **Note the environment.** Hardware, OS, versions. The SOP is only claimed to be true there.

The transcript is scaffolding. It does not ship.

---

### 4. FORGE — compile the transcript into the SOP

Now invert the shape. The transcript is chronological and messy; the SOP is linear and clean, with
the mess moved to the side.

**Produce:** a document conforming to [`sop-format.md`](sop-format.md).

- **`The path`** is the happy route *as it would go now that you know everything*, not as it went.
  Numbered, each step one action with its expected output.
- **`Traps`** holds every wall from RUN: the symptom (verbatim), the cause, the escape. This is
  where the debugging you already paid for gets banked.
- **`Routes not taken`** holds the ROUTE rejections plus anything RUN killed.
- Cut every sentence that does not change what the reader types or decides. Background, history and
  "it is worth noting that" are not SOP material. If context is genuinely required to make a
  decision, it belongs inline at that decision, in one line.

A good SOP is shorter than the transcript it came from by a large factor. If it is not, you are
shipping the walk instead of the road.

---

### 5. KEEP — make it stay true

A SOP starts decaying the moment it is written. This phase is the difference between a framework
and a folder of old notes.

**Produce:** `verified` (date, author, environment) and `recheck_every` in the frontmatter, and a
`Keep fresh` section naming what is expected to rot.

- **Set `recheck_every` from the fastest-moving thing you depend on**, not from how stable the
  topic feels. A guide to a stable protocol that installs via a tool on a 6-week release cycle
  inherits the 6-week cycle.
- Run `zth drift` on a schedule. When a SOP goes stale, it goes back to **RUN** — not to a
  read-through. Re-verification means executing it again. Reading it and deciding it looks fine is
  how a SOP becomes confidently wrong.
- **A re-run that passes unchanged still updates `verified.on`.** That date is the product's
  warranty; renewing it is real work even when the diff is empty.
- If a re-run fails, you are back in the loop: RUN what broke, and if the route itself died, ROUTE
  again from SCOUT's updated evidence.

---

## Choosing scope

One SOP, one done-state. When you find yourself writing "if you want X instead, then...", you have
two SOPs. Split them. A satellite repo holds several related SOPs (`install`, `back-up`,
`upgrade`); each has its own frontmatter, its own verification date, and its own drift clock.
