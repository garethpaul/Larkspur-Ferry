# Main-Thread UI Updates

status: completed

## Context

The ferry schedule and map screens update UIKit and MapKit state from API
completion callbacks. Those callbacks should not retain their view controllers
or assume they are already running on the main queue.

## Objectives

- Dispatch schedule table updates to the main queue before mutating `items` or
  reloading the table.
- Dispatch ferry map annotation updates to the main queue before mutating
  MapKit state.
- Capture view controllers weakly in asynchronous API callbacks.
- Extend the static baseline so the callback contract stays visible without
  Xcode.
- Document the guard beside the existing schedule, location, and map lifecycle
  constraints.

## Verification

- `python3 scripts/check-baseline.py`
- `make check`
- `git diff --check`
