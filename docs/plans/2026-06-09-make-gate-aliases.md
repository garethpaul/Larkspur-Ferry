# Make Gate Aliases

status: completed

## Context

The repository had a single `make check` entry point, but the shared maintenance
workflow expects `make lint`, `make test`, `make build`, and `make check` to be
available before a change is pushed. Without aliases, the first three commands
failed before reaching the static Larkspur Ferry baseline and guarded build
script.

## Completed Scope

- Added `lint`, `test`, and `build` targets that delegate to the existing
  static baseline and guarded build path.
- Extended the baseline to keep those aliases present.
- Updated README, VISION, and CHANGES so the gate contract is visible.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
