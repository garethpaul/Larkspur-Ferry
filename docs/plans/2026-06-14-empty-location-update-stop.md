# Empty Location Update Stop

status: pending

## Context

`didUpdateLocations` marks the location lookup complete before reading the last
sample. When CoreLocation supplies an empty array, the fallback schedule loads
but location updates remain active forever while all later callbacks are
ignored by the single-shot guard.

## Requirements

- Stop location updates before branching on the optional last sample.
- Preserve the single-shot guard and no-location schedule fallback.
- Keep successful reverse geocoding and existing failure behavior unchanged.
- Add a mutation-sensitive ordering contract and completed verification record.

## Scope Boundaries

- Do not change authorization policy, ferry direction selection, API behavior,
  map refreshes, or dependency versions.
- Do not add logging, analytics, persistence, or network behavior.
- Do not claim simulator or physical-device CoreLocation coverage on Linux.

## Planned Verification

- Run all four Make gates from the repository root and `make check` through the
  absolute Makefile path from an external directory.
- Compile the Python checker and run diff, artifact, and changed-line credential
  audits.
- Reject isolated mutations that move cleanup after the empty-location guard,
  remove cleanup or fallback behavior, or falsify plan evidence.
