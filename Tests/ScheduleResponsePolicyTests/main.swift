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

private func expectPublishedItems(_ currentItems: [Int],
                                  _ responseItems: [Int]?,
                                  _ acceptsResponse: Bool,
                                  _ requestedFrom: String,
                                  _ publishedFrom: String?,
                                  _ expectedItems: [Int],
                                  _ message: String) {
    var actualItems = currentItems
    if let itemsToPublish = ferryScheduleItemsToPublish(
        responseItems: responseItems,
        acceptsResponse: acceptsResponse,
        requestedFrom: requestedFrom,
        publishedFrom: publishedFrom
        ) {
        actualItems = itemsToPublish
    }

    if actualItems != expectedItems {
        failureCount += 1
        print("FAIL: \(message): expected \(expectedItems), got \(actualItems)")
    }
}

expectPublishedItems([9], [1, 2], true, "Larkspur", "Larkspur", [1, 2],
                     "current nonempty success publishes")
expectPublishedItems([9], [], true, "Larkspur", "Larkspur", [],
                     "current empty success publishes")
expectPublishedItems([9], nil, true, "Larkspur", "Larkspur", [9],
                     "same-origin failure preserves existing rows")
expectPublishedItems([9], nil, true, "San Francisco", "Larkspur", [],
                     "changed-origin failure clears stale rows")
expectPublishedItems([9], nil, true, "Larkspur", nil, [],
                     "initial failure publishes an empty current schedule")
expectPublishedItems([9], [3], false, "San Francisco", "Larkspur", [9],
                     "stale success does not publish")
expectPublishedItems([9], nil, false, "San Francisco", "Larkspur", [9],
                     "stale failure does not publish")

private func expectParsedSchedule(_ originalRowCount: Int,
                                  _ parsedRowCount: Int,
                                  _ expected: Bool,
                                  _ message: String) {
    let actual = acceptsParsedFerrySchedule(
        originalRowCount: originalRowCount,
        parsedRowCount: parsedRowCount
    )

    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expectParsedSchedule(0, 0, true, "empty provider schedule")
expectParsedSchedule(2, 2, true, "all valid provider rows")
expectParsedSchedule(3, 1, true, "mixed provider rows retain valid entries")
expectParsedSchedule(2, 0, false, "all malformed provider rows")
expectParsedSchedule(-1, 0, false, "negative original row count")
expectParsedSchedule(1, -1, false, "negative parsed row count")
expectParsedSchedule(1, 2, false, "parsed rows exceed original rows")

if failureCount > 0 {
    fatalError("ScheduleResponsePolicy behavioral tests failed: \(failureCount)")
}

print("ScheduleResponsePolicy behavioral tests passed")
