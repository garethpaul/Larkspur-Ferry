# Location Update Single-Shot Plan

status: completed

## Context

`ViewController` uses CoreLocation to choose the initial ferry direction before
loading schedule rows. When location updates, geocoding, or authorization fail,
the app should fall back to loading schedules once instead of leaving location
updates active and repeatedly reloading ferry times.

## Objectives

- Reset location lookup state when a lookup starts.
- Stop CoreLocation updates after a successful location sample, missing sample,
  denied authorization, restricted authorization, geocoder failure, or location
  manager failure.
- Reuse one schedule fallback helper for location-unavailable paths.
- Keep ferry schedule loading available when location is unavailable.
- Extend `make check` so future location flow changes preserve single-shot
  lookup handling.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `sh -n build.sh`
- `git diff --check`
