# Zero to Hero

**An agentic framework for building guides that are actually true, and stay true.**

Give it a topic, a piece of software, or an open question. It produces a SOP that takes a
competent-but-new person from zero to working by the path of least resistance — and then keeps
that SOP honest as the world moves under it.

The method is in [`framework/method.md`](framework/method.md). The rest of this repo is the
machinery that makes it operable.

---

## Why this exists

The internet is full of guides that were never run, for versions that no longer ship, written by
people who hit no problems because they wrote from the docs instead of from a terminal. Asking a
model instead gets you the same thing, faster and more confidently.

Zero to Hero is the opposite bet. Three rules, enforced by tooling:

1. **No step ships unexecuted.** Every command in a SOP was run on a real machine and the observed
   output is what the SOP claims. A step you believe should work is a hypothesis, not a step.
2. **The rejected routes are half the product.** A guide that shows only the winning path invites
   you to re-litigate it. The alternatives and why they lost are written down, so nobody pays that
   cost twice.
3. **A SOP without a freshness contract is a lie with a timestamp.** Every SOP declares when it was
   last *executed* and how long that is good for. `zth drift` fails CI when the clock runs out.

## The loop

```
FRAME → SCOUT → ROUTE → RUN → FORGE → KEEP
                          ↑              │
                          └──────────────┘
```

| Phase | Produces |
|---|---|
| **FRAME** | `done_when` — the destination as assertions that are true or false on a real machine |
| **SCOUT** | Sources with versions and dates, candidate routes, known traps |
| **ROUTE** | The chosen route, scored on five axes, and every rejection with its reason |
| **RUN** | A real transcript from a real machine, including every wall hit |
| **FORGE** | The SOP: linear happy path, traps banked, rejections recorded |
| **KEEP** | A freshness contract, and a drift check that sends you back to RUN |

**Least resistance is not fewest steps.** It is the lowest total cost to the done-state *including
the failures along the way*. A three-command path that fails silently and eats an afternoon is more
resistant than a ten-command path that fails loudly at step four. ROUTE scores candidates on steps,
prerequisites, blast radius, reversibility and staleness risk, and breaks ties toward the loudest
failure. The rubric is in [`framework/method.md`](framework/method.md#2-route--choose-the-path-of-least-resistance-on-the-record).

## Quickstart

```bash
git clone https://github.com/ponzgpt/zero-to-hero.git
zero-to-hero/bin/zth new proxmox
```

That scaffolds a satellite repo carrying the method, an agent entry point, a SOP template and a
scheduled drift check. Then open it with any coding agent and say *"work the Zero to Hero loop for
&lt;topic&gt;"* — `AGENTS.md` and the bundled Claude skill point it at the method.

To add the method to a repo you already have:

```bash
/path/to/zero-to-hero/bin/zth install
```

### Commands

| Command | Does |
|---|---|
| `zth new <slug>` | Scaffold a satellite repo for one topic |
| `zth install [dir]` | Install the method into a repo as `.zth/` |
| `zth update [dir]` | Pull the current framework version into an existing repo |
| `zth check [dir]` | Validate every `sops/*.md` against the format contract |
| `zth drift [dir]` | Report SOPs past their recheck date — exits non-zero, so CI can gate |

## How the repos fit together

One framework repo, many satellite repos, one topic each.

```
zero-to-hero                    ← the method + tooling (this repo)
zero-to-hero-omarchy            ← satellite: sops/, README.md, .zth/
zero-to-hero-proxmox            ← satellite
zero-to-hero-hermes-agent       ← satellite
```

**`zth install` copies the framework into the satellite as `.zth/`.** That directory is
framework-owned in its entirety — user content only ever lives in `sops/` and `README.md`. Which is
why `zth update` is just a re-copy: there is nothing to merge, so there is nothing to conflict.
That single constraint is what buys propagation without a merge tool.

Satellites are found by the **`zero-to-hero` GitHub topic** and listed in the table below.

<details>
<summary>Why separate repos, and not a monorepo, submodules or a template repo</summary>

| Approach | Why not |
|---|---|
| **Monorepo** (`sops/proxmox/`, `sops/omarchy/`) | Good for code that ships together. These do not: each SOP has its own audience, its own release cadence and its own drift clock. And one repo cannot be starred, forked, issue-tracked or sold per topic — which is most of the value when the artifact *is* the document. |
| **Git submodules** | Correct version pinning, wrong product. A reader landing on the Proxmox repo sees an empty directory until they know to run `--recursive`. Paying submodule ergonomics for a docs repo buys nothing here. |
| **Template repository** | Right idea, no propagation: GitHub cuts history at creation, so a framework fix never reaches anything already generated. Fine for scaffolding, useless for maintenance — and maintenance is the whole point. |
| **Copier / cruft** | Solves template propagation properly, by merging template diffs into generated projects. But it exists to handle templates whose output the user edits. Here `.zth/` is never edited, so the merge machinery — and a Python dependency — is solving a problem this design removed. |

`zth install` + `zth update` is the template-repo pattern with the propagation gap closed, at the
cost of one constraint worth keeping anyway: **never edit `.zth/`.**

</details>

## SOP repos

| Repo | Topic | Status |
|---|---|---|
| _none yet_ | | |

## Development

```bash
./tests/run.sh
```

31 assertions against `zth check`, `zth drift` and `zth install`, no framework, no fixtures.

## License

[Apache-2.0](LICENSE). The tooling is yours to use and build on; the trademark clause keeps the
name attached to the method.
