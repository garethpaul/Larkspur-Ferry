# Map Refresh Timer Lifecycle Plan

status: completed

## Context

`MapViewController` refreshes ferry location data every 30 seconds while showing the map. The timer was created as a local value in `viewDidLoad`, which left no lifecycle hook for invalidation when the map screen disappeared.

## Objectives

- Keep the initial and repeating ferry-location refresh behavior.
- Store the map refresh timer on the controller so lifecycle methods can manage it.
- Start the timer when the map screen appears.
- Invalidate and clear the timer when the map screen disappears.
- Extend `make check` so future map flow changes preserve timer lifecycle handling.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `sh -n build.sh`
- `git diff --check`
