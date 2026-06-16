private var failureCount = 0

private func expect(_ requestedFrom: String,
                    _ requestedRevision: Int,
                    _ currentFrom: String,
                    _ currentRevision: Int,
                    _ expected: Bool,
                    _ message: String) {
    let actual = acceptsFerryScheduleResponse(
        requestedFrom: requestedFrom,
        requestedDirectionRevision: requestedRevision,
        currentFrom: currentFrom,
        currentDirectionRevision: currentRevision
    )

    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect("Larkspur", 0, "Larkspur", 0, true, "initial Larkspur response")
expect("San Francisco", 4, "San Francisco", 4, true, "current San Francisco response")
expect("Larkspur", 1, "San Francisco", 1, false, "changed origin")
expect("San Francisco", 2, "Larkspur", 2, false, "reverse changed origin")
expect("Larkspur", 3, "Larkspur", 5, false, "tap-away-and-back stale response")
expect("San Francisco", 8, "San Francisco", 9, false, "newer same-origin request")
expect("", 0, "", 0, false, "empty origin")
expect("Sausalito", 2, "Sausalito", 2, false, "unknown origin")

if failureCount > 0 {
    fatalError("ScheduleResponsePolicy behavioral tests failed: \(failureCount)")
}

print("ScheduleResponsePolicy behavioral tests passed")
