# Transit Data Source And Freshness Documentation

Status: completed

## Scope

Complete the bounded roadmap item for current transit-data source and freshness
expectations without changing the legacy endpoint, request cadence, parsing, or
publication behavior.

## Work Completed

- Record the project-specific proxy base URL and both checked-in request paths.
- Distinguish user-triggered schedule loading from 30-second visible-map
  location polling.
- Explain the uncached 10-second client request boundary without presenting it
  as proof of upstream freshness.
- Document missing server timestamps, attribution, feed versions, and freshness
  guarantees.
- Explain when failed requests retain prior schedule rows or the last known
  ferry pin and why retained data must not be treated as current.

## Verification Completed

- Cross-checked the documented base URL, request paths, 10-second timeout,
  uncached request policy, and 30-second map cadence against the checked-in
  Swift source.
- Confirmed the baseline checker failed for every missing guide, link, roadmap,
  and plan contract before the documentation was added.
- Thirteen isolated hostile documentation mutations were rejected for source,
  cadence, cache, timeout, timestamp, freshness, travel-warning, link, roadmap,
  and completed-plan drift.
- `python3 -m py_compile scripts/check-baseline.py`, the guarded
  `SKIP_XCODE_BUILD=1 ./build.sh` path, and `git diff --check` passed locally.
- This Linux host has neither `swiftc` nor Xcode and retains the repository's
  pre-existing `/bin/sh` Make-root incompatibility.
- Exact-head hosted macOS `make check` passed on both push and pull-request
  runs, including the Swift policy harnesses, static baseline, and guarded
  legacy build boundary. CodeQL Actions and Python analysis also passed.

## Residual Risk

The proxy's upstream provider, ownership, update process, and continued
availability are not identified in this repository. Documentation cannot make
the legacy endpoint authoritative; travelers must verify current information
independently.
