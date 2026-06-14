# Empty Location Update Stop

status: completed

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

## Work Completed

- Moved CoreLocation cleanup ahead of the optional last-sample guard.
- Preserved the single-shot state transition, empty-sample schedule fallback,
  successful geocoding, and existing failure handling.
- Replaced the over-broad cleanup contract with callback-scoped ordering checks.

## Verification Completed

- Python checker compilation passed. Before this completion record was added,
  the baseline reached only the expected pending-plan evidence failure.
- `make lint`, `make test`, `make build`, and `make check` passed from the
  repository root; `make check` also passed through the absolute Makefile path.
- Six isolated hostile mutations were rejected: removing or moving cleanup,
  removing the single-shot state transition, replacing the last-sample guard,
  reverting plan status, and erasing hostile-mutation verification evidence.
- CocoaPods and Xcode were unavailable on this Linux host, so simulator,
  physical-device, and live CoreLocation behavior are not claimed.
