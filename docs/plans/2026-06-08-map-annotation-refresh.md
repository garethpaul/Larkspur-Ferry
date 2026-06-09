# Map Annotation Refresh Plan

status: completed

## Context

The map view refreshes ferry location data on a timer. The old cleanup path only removed annotations when the map had exactly one annotation, which could leave stale ferry pins behind once the map contained any other annotation.

## Objectives

- Remove prior ferry annotations before adding the refreshed ferry location.
- Preserve unrelated map annotations when refreshing ferry position data.
- Avoid relying on the total annotation count to decide whether cleanup is needed.
- Extend the static baseline and docs to keep ferry annotation refresh behavior visible.

## Verification

- `make check`
- `git diff --check`
