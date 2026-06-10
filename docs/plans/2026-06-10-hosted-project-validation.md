# Hosted Project Validation

status: completed

## Context

The repository has focused static checks for ferry API boundaries, location and
timer lifecycles, main-thread UI updates, map annotation refresh, CocoaPods
metadata, and build-script syntax, but no current hosted validation. Running the
canonical gate on macOS would otherwise install obsolete pods and attempt an
iPhone 5 simulator build.

## Priorities

1. Add pinned, read-only, bounded macOS CI for the canonical `make check` gate.
2. Add an explicit hosted-validation mode that skips dependency installation
   and the legacy simulator build while preserving normal developer behavior.
3. Parse `Larkspur Ferry.xcodeproj` whenever Xcode is available.
4. Keep location access, ferry API calls, CocoaPods installation, signing,
   simulator execution, and UI tests outside hosted structural validation.

## Implementation Units

### Workflow, Build Guard, And Checker

Files:

- `.github/workflows/check.yml`
- `build.sh`
- `scripts/check-baseline.py`

Add push, pull-request, and manual triggers; read-only permissions; concurrency
cancellation; a bounded `macos-15` job; commit-pinned checkout; the explicit
`SKIP_XCODE_BUILD=1` environment boundary; and `make check`. Require those
properties and run `xcodebuild -list -project "Larkspur Ferry.xcodeproj"` when
Xcode exists.

### Documentation

Files:

- `README.md`
- `VISION.md`
- `SECURITY.md`
- `CHANGES.md`
- `docs/plans/2026-06-10-hosted-project-validation.md`

Document project parsing as structural validation only, not dependency,
network, location, simulator, or UI-test coverage.

## Verification

- `python3 -m py_compile scripts/check-baseline.py`
- `sh -n build.sh`
- `SKIP_XCODE_BUILD=1 make lint`
- `SKIP_XCODE_BUILD=1 make test`
- `SKIP_XCODE_BUILD=1 make build`
- `SKIP_XCODE_BUILD=1 make check`
- workflow YAML parse
- `git diff --check`
- successful hosted macOS `Check` workflow for the pushed commit

## Boundaries

- Do not install pods, call the ferry API, or request location in CI.
- Do not introduce signing material or claim full legacy Swift build support.
