# Changes

## 2026-06-08

- Fixed `build.sh` to use POSIX shell function syntax and skip cleanly when CocoaPods or Xcode are unavailable.
- Hardened API parsing for ferry location and schedule responses to remove force-unwrapping of malformed data.
- Removed app debug logging from location and network failure paths.
- Made location fallback behavior show ferry times when authorization, geocoding, or location updates are unavailable.
- Removed the tracked `.DS_Store` from the asset catalog and added a static `make check` baseline.
