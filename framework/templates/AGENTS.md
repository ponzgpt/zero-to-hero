# Agent instructions

This repo is a **Zero to Hero** SOP repo. The method is normative and lives at
[`.zth/method.md`](.zth/method.md); the output contract is [`.zth/sop-format.md`](.zth/sop-format.md).

Read both before writing or editing anything under `sops/`.

## Non-negotiables

1. **Never write a step you have not executed.** If you cannot run it here, say so and mark the SOP
   `status: draft`. A plausible command is not a verified one.
2. **Record the routes you rejected**, in the vocabulary of the ROUTE rubric.
3. **Touching a SOP's path means re-verifying it.** Update `verified.on` only after an actual run.
   Never bump that date because the text looks fine.
4. **`.zth/` is framework-owned.** Never edit it; `zth update` overwrites it wholesale. Your work
   goes in `sops/` and `README.md`.

## Before you finish

```bash
.zth/bin/zth check
.zth/bin/zth drift
```

Both must pass.
