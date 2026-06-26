# Configurable API Base URL Implementation Plan

Status: completed

## Goal

Move the legacy ferry proxy base URL from a private source literal into
documented app configuration without allowing malformed, insecure, or
credential-bearing endpoint values to reach Alamofire.

## Design

- Add `FerryAPIBaseURL` to the checked-in app `Info.plist`, preserving the
  current `https://requestlabs.appspot.com/` behavior by default.
- Resolve the value through a Foundation-only policy that accepts a nonblank
  absolute HTTPS URL with a host and no user, password, query, or fragment.
- Normalize a missing trailing slash so the existing relative request paths
  remain stable.
- Fail closed before request construction when configuration is absent or
  invalid.
- Exercise the production policy with a standalone Swift harness from every
  Make verification alias.
- Repair the pre-existing POSIX-shell failure in the apostrophe-path Make root
  guard discovered while running the required full gate.
- Document configuration, validation, and transit-data maintenance rules.

## Verification

1. Run the focused Swift harness before implementation and observe compiler
   failure because `APIBaseURLPolicy.swift` does not exist.
2. Implement the policy and runtime wiring, then rerun the focused harness.
3. Extend the static baseline and hostile mutation coverage for source,
   project, plist, documentation, and completed-plan drift.
4. Run all Make aliases, the guarded build path, and `git diff --check`.
5. Require exact-head hosted validation before merge.

## Risks

- A missing or malformed deployed plist value now prevents requests instead of
  silently using a hidden source default; the checked-in plist supplies the
  current value.
- The legacy proxy remains unauthenticated and without a freshness guarantee;
  this change only makes endpoint ownership explicit.

## Work Completed

- Added the checked-in `FerryAPIBaseURL` plist setting and removed the private
  endpoint literal from `API.swift`.
- Added a Foundation-only validation policy, app-target wiring, and a
  standalone executable Swift test harness.
- Updated the README, transit-data guide, vision, changelog, project file,
  Make authority contract, and static baseline.
- Replaced the Make root resolver's shell-invalid escaped parameter expansion
  with a quoted POSIX `sed` trim while preserving hostile-path behavior.

## Verification Completed

- The RED container run failed because `APIBaseURLPolicy.swift` did not exist.
- The focused policy and both existing response-policy harnesses passed under
  cached Swift 5.10, 6.0, and 6.2 containers.
- Ten isolated hostile mutations were rejected for scheme, host, user,
  password, query, fragment, bundle lookup, plist, project-source, and Make
  runner weakening.
- All four Make gates passed from the repository root, and the absolute
  external Makefile gate passed from a hostile path containing spaces, an
  apostrophe, and brackets.
- Python compilation, plist parsing, guarded legacy build behavior, and
  `git diff --check` passed. Xcode and CocoaPods execution remain delegated to
  exact-head hosted macOS validation.
