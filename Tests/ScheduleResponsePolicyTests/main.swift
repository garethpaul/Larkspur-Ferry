private var failureCount = 0

private func expect(_ requestedFrom: String,
                    _ requestedRevision: Int,
                    _ requestedRequestRevision: Int,
                    _ currentFrom: String,
                    _ currentRevision: Int,
                    _ currentRequestRevision: Int,
                    _ expected: Bool,
                    _ message: String) {
    let actual = acceptsFerryScheduleResponse(
        requestedFrom: requestedFrom,
        requestedDirectionRevision: requestedRevision,
        requestedScheduleRequestRevision: requestedRequestRevision,
        currentFrom: currentFrom,
        currentDirectionRevision: currentRevision,
        currentScheduleRequestRevision: currentRequestRevision
    )

    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect("Larkspur", 0, 1, "Larkspur", 0, 1, true, "initial Larkspur response")
expect("San Francisco", 4, 7, "San Francisco", 4, 7, true, "current San Francisco response")
expect("Larkspur", 1, 3, "San Francisco", 1, 3, false, "changed origin")
expect("San Francisco", 2, 4, "Larkspur", 2, 4, false, "reverse changed origin")
expect("Larkspur", 3, 5, "Larkspur", 5, 6, false, "tap-away-and-back stale response")
expect("San Francisco", 8, 9, "San Francisco", 9, 10, false, "newer same-origin direction request")
expect("Larkspur", 6, 11, "Larkspur", 6, 12, false, "newer same-origin schedule request")
expect("", 0, 1, "", 0, 1, false, "empty origin")
expect("Sausalito", 2, 4, "Sausalito", 2, 4, false, "unknown origin")

if failureCount > 0 {
    fatalError("ScheduleResponsePolicy behavioral tests failed: \(failureCount)")
}

print("ScheduleResponsePolicy behavioral tests passed")
