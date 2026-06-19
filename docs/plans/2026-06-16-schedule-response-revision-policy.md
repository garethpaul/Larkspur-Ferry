---
title: Execute schedule response revision policy
type: reliability
date: 2026-06-16
status: completed
execution: code
---

# Execute schedule response revision policy

## Goal

Prevent an older ferry schedule callback from publishing after a user toggles
away from and back to the same origin, and execute that production decision in
hosted verification without depending on live transit data or the legacy UI
test stack.

## Requirements

- Accept a schedule callback only when its origin, direction revision, and
  request revision all match current controller state.
- Reject unknown origins, tap-away-and-back callbacks from older revisions, and
  older same-origin callbacks when a newer schedule request is already active.
- Keep the pure policy in the app target and delegate the callback guard to it.
- Compile and execute the production policy from every Make gate when `swiftc`
  is available.
- Preserve the legacy UI test target as context without claiming it executes.

## Verification Completed

- All four Make gates passed from the repository root.
- The external absolute Makefile gate passed from `/tmp`.
- Fake-compiler success, exit-7 failure, signal-143 cleanup, and temporary-build
  cleanup probes passed for the standalone runner.
- Nine hostile mutations were rejected across origin validation, direction and
  request revision matching, controller delegation, app-target membership,
  executable cases, runner cleanup, Make wiring, and completed plan evidence.
- Shell and Python syntax, project references, executable modes, diff checks,
  artifact scans, and changed-line credential-pattern scans passed.
- `swiftc` and Xcode are unavailable on this Linux host. On implementation head
  `96748de8f936e816096e7addef855198304337b1`, hosted push run `27643518037`
  and hosted pull-request check run `27643523921` passed; both logs recorded the
  production policy harness and maintained baseline passing.
