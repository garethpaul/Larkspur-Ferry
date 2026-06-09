# AGENTS.md

## Repository purpose

`garethpaul/Larkspur-Ferry` is an Apple platform application or Swift sample. iOS App Larkspur Ferry

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Podfile` - CocoaPods dependency definition
- `Larkspur Ferry.xcodeproj` - Xcode project
- `Larkspur Ferry.xcworkspace` - Xcode workspace
- `Larkspur Ferry` - repository source or sample assets
- `Larkspur FerryUITests` - repository source or sample assets
- `Screenshots` - repository source or sample assets

## Development commands

- Install dependencies: `pod install`
- Full baseline: `make check`
- Local Apple development: `open Larkspur Ferry.xcworkspace`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: Swift (10), shell (1).
- Use the CocoaPods workspace when present; update `Podfile.lock` only with an intentional dependency change.
- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- Test-related files detected: `Larkspur Ferry.xcodeproj/xcshareddata/xcschemes/Larkspur FerryUITests.xcscheme`, `Larkspur FerryUITests/Larkspur_FerryUITests.swift`
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- The app uses the documented HTTPS ferry API endpoint in `Larkspur Ferry/API.swift`.
- Keep API credentials, signing files, local CocoaPods output, and generated app data out of git if any are introduced later.
- Location is requested only for in-app ferry direction assistance and should fall back to schedule loading when unavailable.
- Do not add force-unwrapped API payloads, force-unwrapped location data, or app debug logging for transit/location failures.
- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make lint`, `make test`, `make build`, and `make check` before pushing Swift, build-script, Podfile, storyboard, plist, asset, or security documentation changes.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
