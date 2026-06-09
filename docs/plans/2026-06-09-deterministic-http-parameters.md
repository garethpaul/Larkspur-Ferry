# Deterministic HTTP Parameters Plan

status: completed

## Context

`stringFromHttpParameters()` percent-encodes dictionary keys and values before
building the ferry API query string. Dictionary iteration order is not stable,
so future multi-parameter API calls can produce different query-string ordering
for the same inputs.

## Objectives

- Keep key and value percent encoding before query construction.
- Sort encoded parameter pairs before joining them.
- Preserve the existing nil-skipping behavior for non-string keys or failed
  percent encoding.
- Extend the static baseline so deterministic query ordering remains visible.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
