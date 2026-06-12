# Validated Ferry Responses

status: completed

## Problem

The Alamofire request path accepts any HTTP status/content type for JSON parsing,
uses the default cache policy for live ferry data, and has no explicit timeout.

## Scope

- Set a 10-second request timeout.
- Ignore local cache data for live location and schedule requests.
- Accept only HTTP 2xx responses with `application/json` content.
- Preserve nil/empty failure behavior and existing main-thread UI delivery.
- Add static and mutation guardrails without calling the live API in CI.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- mutation checks for status/content validation and timeout/cache policy
- `git diff --check`
