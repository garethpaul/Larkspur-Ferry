# Spaced Makefile Path

status: completed

## Problem

GNU Make list functions split `MAKEFILE_LIST` on whitespace. The documented
absolute `make -f` invocation therefore failed when the checkout path contained
spaces, even though ordinary external-directory paths passed.

## Change

1. Derive the repository root from the raw Makefile path with shell-safe
   single-quote escaping.
2. Reject command-line and `-e` environment attempts to replace GNU Make's
   automatic `MAKEFILE_LIST` value.
3. Keep `override ROOT` so callers cannot redirect the gate.
4. Exercise all four aliases from an unrelated directory with a checkout path
   containing spaces, brackets, and a literal apostrophe.

## Verification

- Root and external `check`, `lint`, `test`, and `build` aliases passed.
- Command-line and environment `ROOT` attacks stayed rooted in the checkout.
- Command-line and environment `MAKEFILE_LIST` attacks failed closed.
- Linux truthfully skipped Swift, CocoaPods, and Xcode execution while the
  static ferry baseline and guarded build path passed.
