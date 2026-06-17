private var failureCount = 0

private func expect(_ requestedRevision: Int,
                    _ currentRevision: Int,
                    _ expected: Bool,
                    _ message: String) {
    let actual = acceptsFerryLocationResponse(
        requestedRevision: requestedRevision,
        currentRevision: currentRevision
    )

    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect(0, 0, true, "initial request")
expect(7, 7, true, "latest request")
expect(6, 7, false, "older overlapping request")
expect(8, 7, false, "noncurrent future request")
expect(3, 4, false, "disappearance invalidation")

if failureCount > 0 {
    fatalError("LocationResponsePolicy behavioral tests failed: \(failureCount)")
}

print("LocationResponsePolicy behavioral tests passed")
