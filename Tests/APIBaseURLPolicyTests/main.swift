import Foundation

private var failureCount = 0

private func expect(_ rawValue: Any?, _ expected: String?, _ message: String) {
    let actual = validatedFerryAPIBaseURL(rawValue)?.absoluteString
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(String(describing: expected)), got \(String(describing: actual))")
    }
}

expect("https://requestlabs.appspot.com/",
       "https://requestlabs.appspot.com/",
       "current HTTPS endpoint")
expect("  https://example.com/ferry/  ",
       "https://example.com/ferry/",
       "surrounding whitespace")
expect("https://example.com/ferry",
       "https://example.com/ferry/",
       "missing trailing slash")
expect(nil, nil, "missing configuration")
expect(42, nil, "non-string configuration")
expect("", nil, "empty configuration")
expect("   ", nil, "blank configuration")
expect("http://example.com/", nil, "insecure scheme")
expect("ftp://example.com/", nil, "unsupported scheme")
expect("https:///ferry/", nil, "missing host")
expect("https://user:secret@example.com/", nil, "embedded credentials")
expect("https://example.com/ferry/?token=secret", nil, "query string")
expect("https://example.com/ferry/#section", nil, "fragment")

if failureCount > 0 {
    exit(1)
}

print("API base URL policy tests passed")
