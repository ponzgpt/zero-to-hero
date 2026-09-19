# zero-to-hero
The Zero to Hero method and its `zth` CLI. `framework/` is the payload `zth install` copies into satellite repos as `.zth/`. Live: https://zero-to-hero.technoir.cloud (README rendered). The method is `framework/method.md`; the SOP contract is `framework/sop-format.md`.

## Commands
- Check (before every commit and deploy): `./tests/run.sh`, which must pass on macOS and Linux (CI runs both).
- Deploy the page: `./scripts/deploy.sh`

## Non-negotiables
1. `framework/` is published API: every change reaches every satellite on `zth update`.
2. Satellites never edit `.zth/`; anything they'd customise goes in `framework/templates/`, seeded once.
3. `bin/zth` runs from this checkout and from an installed `.zth/bin/zth`; every path change works from both.
4. Changing the SOP format changes `sop-format.md`, the `KEYS`/`SECTIONS` arrays in `bin/zth` and `framework/templates/SOP.md` together, and bumps `framework/VERSION`.
5. `zth` uses BSD `date` with a GNU fallback; keep both working.
