# Changes

## 2026-06-17

- Added a revision-aware ferry-location response policy so an older overlapping
  callback cannot replace a newer map position or publish after disappearance.
- Added finite coordinate domain validation so numeric but invalid ferry
  latitude and longitude values cannot reach MapKit.

## 2026-06-16

- Added a revision-aware schedule response policy so tap-away-and-back callbacks
  cannot publish an older same-origin schedule.
- Added a standalone Swift harness that executes the production policy across
  nine deterministic origin, direction revision, and request revision cases from
  every Make gate.

## 2026-06-15

- Rejected a stale geocoder completion after a newer manual ferry direction
  change, including tap-away-and-back sequences.

## 2026-06-14

- Aligned location-derived direction state with the canonical schedule origin
  before updating direction images or requesting ferry times.
- Stopped CoreLocation updates before falling back from an empty location
  callback.
- Prevented in-flight ferry location responses from mutating the map after its
  screen disappears.

## 2026-06-13

- Made every Make verification alias resolve the checker and guarded build
  script from the checkout, including absolute Makefile invocations elsewhere.

## 2026-06-12

- Disabled persisted checkout credentials and enforced the sole pinned
  credential-free workflow boundary without changing stale-response handling.

## 2026-06-10

- Rejected a stale schedule response when a newer ferry direction selection is
  already active.
- Added uncached 10-second ferry requests with HTTP status and JSON content-type
  validation before response parsing.
- Added pinned, read-only macOS hosted project validation with an explicit
  `SKIP_XCODE_BUILD=1` boundary around obsolete CocoaPods and simulator work.
- Preserved the last known ferry pin during failed map-location refresh
  responses until a successful refresh can replace it.

## 2026-06-09

- Added local `make lint`, `make test`, and `make build` gate aliases for the
  static Larkspur Ferry baseline and guarded build path.
- Kept locale-independent coordinate parsing for ferry API latitude and
  longitude strings across device regions.
- Sorted percent-encoded API parameter pairs for deterministic query strings.
- Added POSIX schedule time parsing for fixed-format ferry API departure values.
- Kept schedule table and map callbacks on main-thread UI updates before
  mutating UIKit or MapKit state.

## 2026-06-08

- Fixed `build.sh` to use POSIX shell function syntax and skip cleanly when CocoaPods or Xcode are unavailable.
- Hardened API parsing for ferry location and schedule responses to remove force-unwrapping of malformed data.
- Tied the map refresh timer to the map screen lifecycle so ferry-location polling stops when the view disappears.
- Hardened ferry annotation refresh so stale ferry pins are removed without clearing unrelated map annotations.
- Made the initial direction lookup a single-shot location flow so unavailable CoreLocation or geocoder data falls back without repeated schedule reloads.
- Removed app debug logging from location and network failure paths.
- Made location fallback behavior show ferry times when authorization, geocoding, or location updates are unavailable.
- Removed the tracked `.DS_Store` from the asset catalog and added a static `make check` baseline.
- Pointed local Xcode setup at the CocoaPods workspace and corrected generated integration docs.
