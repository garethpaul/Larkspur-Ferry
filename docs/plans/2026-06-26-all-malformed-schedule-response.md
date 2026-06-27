# All-Malformed Schedule Response Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Preserve valid displayed schedule rows when a nonempty provider array contains no parseable ferry rows.

**Architecture:** Extend the existing Foundation-free schedule response policy with a count-based payload acceptance rule. Empty arrays remain valid empty schedules, mixed arrays retain valid rows, and nonempty arrays with zero valid rows become request failures before publication policy runs.

**Tech Stack:** Swift 3-compatible policy code, standalone `swiftc` harnesses, Python static/mutation contracts, GNU Make, hosted Xcode validation.

---

Status: Completed

### Task 1: Add the failing payload-policy tests

**Files:**
- Modify: `Tests/ScheduleResponsePolicyTests/main.swift`

Add cases for an empty valid array, all-valid rows, mixed valid/malformed rows,
all-malformed rows, and impossible negative or over-count inputs.

Run: `scripts/run-schedule-response-policy-tests.sh`
Expected: compile failure because `acceptsParsedFerrySchedule` does not exist.

### Task 2: Implement and wire the policy

**Files:**
- Modify: `Larkspur Ferry/ScheduleResponsePolicy.swift`
- Modify: `Larkspur Ferry/API.swift`

Implement `acceptsParsedFerrySchedule(originalRowCount:parsedRowCount:)` and
return `nil` from `getTimes` when a nonempty array produces zero valid boats.
Keep empty arrays and partial valid parsing behavior unchanged.

Run: `scripts/run-schedule-response-policy-tests.sh`
Expected: all schedule policy tests pass.

### Task 3: Preserve contracts and evidence

**Files:**
- Modify: `scripts/check-baseline.py`
- Modify: `CHANGES.md`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `DATA_SOURCE.md`

Add source and hostile mutation coverage, document the provider-data boundary,
and mark the existing schedule-fixture roadmap priority complete.

Run: `make check`
Expected: all Swift policy harnesses and baseline mutations pass; guarded Xcode
validation skips locally only when its documented toolchain is unavailable.

Observed: API base URL, schedule response, and location response policy
harnesses pass under cached Swift 5.10, 6.0, and 6.2 containers. The static
baseline, Python and shell syntax, `git diff --check`, all four root Make aliases,
and the absolute external Makefile gate pass with `SKIP_XCODE_BUILD=1`; hosted
macOS remains authoritative for project parsing.
