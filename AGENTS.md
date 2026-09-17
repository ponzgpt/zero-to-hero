# Agent instructions

This is the **Zero to Hero framework** repo — the method and its tooling. It is not a SOP repo;
satellite repos are, and they get their copy of the method from here.

- [`framework/method.md`](framework/method.md) — the method. Normative.
- [`framework/sop-format.md`](framework/sop-format.md) — the SOP contract that `zth check` enforces.

## Layout

| Path | What it is |
|---|---|
| `framework/` | **The payload.** `zth install` copies this into a satellite as `.zth/`. |
| `framework/templates/` | What `zth new` and `zth install` seed into a repo. |
| `bin/zth` | The CLI. Runs both from this checkout and from an installed `.zth/bin/zth`. |
| `tests/run.sh` | The check. No framework, no fixtures. |

## Non-negotiables

1. **`framework/` is load-bearing for every satellite.** A change here reaches every repo that runs
   `zth update`. Treat it as published API, not as notes.
2. **`.zth/` is framework-owned wherever it is installed**, which is the whole reason `update` can
   be a re-copy. Anything that would make a satellite want to edit `.zth/` breaks propagation —
   put it in `framework/templates/` so it is seeded once instead.
3. **`bin/zth` runs from two roots** — this checkout (`framework/method.md`) and an installed copy
   (`method.md`). Any path change has to work from both.
4. **Changing the SOP format means changing three things together**: `sop-format.md`, the `KEYS` /
   `SECTIONS` arrays in `bin/zth`, and `framework/templates/SOP.md`. Bump `framework/VERSION`.

## Before committing

```bash
./tests/run.sh
```

Non-trivial logic gets an assertion there. It must pass on both macOS and Linux — `zth` uses BSD
`date` with a GNU fallback, and CI runs both.
