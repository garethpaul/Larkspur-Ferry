# Larkspur-Ferry

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/Larkspur-Ferry` is an Apple platform application or Swift sample. iOS App Larkspur Ferry

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Swift (10), shell (1).

## Repository Contents

- `CHANGES.md` - recent maintenance changes
- `Makefile` - local static verification entry point
- `README.md` - project overview and local usage notes
- `Podfile` - Apple platform dependency metadata
- `build.sh`
- `Larkspur Ferry` - source or example code
- `Larkspur Ferry.xcodeproj` - Xcode project file
- `Larkspur FerryUITests` - source or example code
- `Podfile.lock` - Apple platform dependency metadata
- `scripts/check-baseline.py` - static Swift/API/location baseline checks
- `SECURITY.md` - security reporting and disclosure guidance
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: Larkspur Ferry, Larkspur FerryUITests
- Dependency and build manifests: Podfile, Podfile.lock
- Entry points or build surfaces: `make check`, build.sh, Larkspur Ferry.xcodeproj
- Test-looking files: Larkspur FerryUITests/Info.plist, Larkspur FerryUITests/Larkspur_FerryUITests.swift, Larkspur FerryUITests/SnapshotHelper.swift

## Getting Started

### Prerequisites

- Git
- Python 3 for static verification with `make check`
- macOS with Xcode for building Apple platform projects
- CocoaPods if dependencies need to be installed

### Setup

```bash
git clone https://github.com/garethpaul/Larkspur-Ferry.git
cd Larkspur-Ferry
make check
pod install
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Open `Larkspur Ferry.xcworkspace` in Xcode after `pod install`, choose the app or sample scheme, and run it on the matching simulator/device.
- Run `./build.sh` when the required platform toolchain is installed.
- `build.sh` skips cleanly on hosts without CocoaPods or Xcode so static checks can run on non-macOS machines.
- The map refresh timer starts while the map screen is visible and is invalidated when the screen disappears.
- The initial direction lookup is a single-shot location flow; unavailable or failed CoreLocation/geocoder data falls back to schedule loading.

## Testing and Verification

- `make check` runs `scripts/check-baseline.py` and the guarded `build.sh` path. The checker verifies build-script syntax, plist/storyboard/asset parsing, Podfile lock metadata, API parsing guardrails, single-shot location fallbacks, map refresh timer lifecycle handling, and generated metadata ignores.
- Xcode's test action or `xcodebuild test` with the appropriate scheme and destination

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- The app uses the documented HTTPS ferry API endpoint in `Larkspur Ferry/API.swift`.
- Keep API credentials, signing files, local CocoaPods output, and generated app data out of git if any are introduced later.
- Location is requested only for in-app ferry direction assistance and should fall back to schedule loading when unavailable.

## Security and Privacy Notes

- Review changes touching external API calls or credential-adjacent configuration; examples from the scan include Larkspur Ferry/Info.plist.
- Review changes touching network requests, sockets, or service endpoints; examples from the scan include Larkspur Ferry/API.swift, Larkspur Ferry/Extensions.swift, Larkspur Ferry/Info.plist, Larkspur FerryUITests/Info.plist, and 2 more.
- Review changes touching mobile permissions or privacy-sensitive device data; examples from the scan include Larkspur Ferry/API.swift, Larkspur Ferry/MapViewController.swift, Larkspur Ferry/ViewController.swift.
- Do not add force-unwrapped API payloads, force-unwrapped location data, or app debug logging for transit/location failures.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include Larkspur Ferry/API.swift, Larkspur Ferry/Info.plist, Larkspur Ferry/MapViewController.swift, Larkspur Ferry/ViewController.swift, and 1 more.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make check` before pushing Swift, build-script, Podfile, storyboard, plist, asset, or security documentation changes.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
