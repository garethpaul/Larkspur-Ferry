# Stale Schedule Response Guard

status: planned

## Context

Each direction toggle immediately requests a new ferry schedule. The callback
currently replaces the table contents without checking which direction the
response belongs to, so out-of-order network completions can display a stale
schedule after the user has already selected the opposite direction.

## Priorities

1. Capture the selected direction when a schedule request starts.
2. Apply the response only while that direction remains current.
3. Preserve main-thread UIKit updates and weak controller ownership.
4. Keep API behavior, dependencies, and the no-network static gate unchanged.

## Implementation Units

### Schedule Callback

File: `Larkspur Ferry/ViewController.swift`

Capture `f` before calling `API.getTimes` and require the current selection to
match that captured value before replacing `items` or reloading the table.

### Static Regression Contract

File: `scripts/check-baseline.py`

Require the captured request direction and current-selection comparison near
the existing weak-self and main-thread callback contract.

### Documentation

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `docs/plans/2026-06-12-stale-schedule-response-guard.md`

Document that a late response cannot overwrite a newer direction selection.

## Verification

- `python3 -m py_compile scripts/check-baseline.py`
- `make lint`
- `make test`
- `make build`
- `make check`
- hostile mutations removing the captured direction or equality guard
- `git diff --check`
- hosted macOS project validation for push and pull-request events

## Boundaries

- Do not add live API requests to tests or CI.
- Do not replace Alamofire or alter the endpoint contract in this change.
- Do not discard the existing table while a newer request is pending.
