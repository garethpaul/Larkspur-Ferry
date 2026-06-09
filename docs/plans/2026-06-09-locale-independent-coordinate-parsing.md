# Locale-Independent Coordinate Parsing

status: completed

## Context

The ferry location API returns latitude and longitude strings with decimal
points. Parsing those coordinates through `NumberFormatter()` can depend on the
device locale, which risks failing or misreading valid API coordinates on
devices configured for different decimal separators.

## Objectives

- Parse API coordinate strings with Swift's locale-independent `Double`
  initializer.
- Keep malformed coordinate strings returning `nil` so the existing API
  completion fallback still runs.
- Extend the static baseline so locale-independent coordinate parsing stays
  visible without Xcode.
- Document the guard in the README, vision, security policy, and change log.

## Verification

- `python3 scripts/check-baseline.py`
- `make check`
- `git diff --check`
