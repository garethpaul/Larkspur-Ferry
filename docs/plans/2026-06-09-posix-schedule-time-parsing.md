# POSIX Schedule Time Parsing

status: completed

## Context

The ferry schedule table parses API departure strings with a fixed `HH:mm`
format before displaying them as 12-hour times. Fixed-format API values should
not depend on the user's device locale when table cells are rendered.

## Objectives

- Use a POSIX locale for fixed-format ferry API departure parsing.
- Preserve the existing fallback that displays the original API string when
  parsing fails.
- Keep table index, cell-cast, and invalid-time guards unchanged.
- Extend the static baseline so schedule time parsing stays visible without
  Xcode.
- Document the guard beside coordinate parsing and request-construction
  stability.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
