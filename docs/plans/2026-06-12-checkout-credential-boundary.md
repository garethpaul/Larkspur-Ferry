# Checkout Credential Boundary

status: completed

## Context

Canonical PR #7 preserves a newer stale-schedule-response guard, but its hosted
checkout still retained the read-only workflow token in the runner's Git
configuration. An older divergent branch already disabled persistence but also
lacked the newer schedule protection, so only the credential boundary is
reapplied here.

## Implementation

- Set `persist-credentials: false` on the single commit-pinned checkout step.
- Require exactly one checkout action and only the canonical workflow file.
- Preserve the macOS 15 runner, `SKIP_XCODE_BUILD=1`, read-only permission,
  timeout, concurrency, and `make check` command.
- Preserve the stale-schedule-response code, checker, plan, and documentation.

## Verification

- `make lint`, `make test`, `make build`, and `make check` passed.
- The checker passed from an external working directory.
- Workflow YAML parsing, Python compilation, and `git diff --check` passed.
- Focused hostile mutations rejected a missing or true credential setting,
  duplicate checkout action, extra workflow file, incomplete plan, stale
  documentation, and removal of the stale-response guard; all hostile
  mutations rejected.
- Exact-head hosted verification remains pending until this successor is
  pushed.

## Boundaries

- Do not import the divergent predecessor branch wholesale.
- Do not weaken stale schedule response rejection, ferry response validation,
  location fallbacks, or map refresh behavior.
- Do not add post-checkout pushes, tags, or authenticated Git fetches.
