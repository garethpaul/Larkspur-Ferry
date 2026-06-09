# Changes

## 2026-06-09

- Kept locale-independent coordinate parsing for ferry API latitude and
  longitude strings across device regions.
- Sorted percent-encoded API parameter pairs for deterministic query strings.

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
