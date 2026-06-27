func acceptsFerryScheduleResponse(requestedFrom: String,
                                  requestedDirectionRevision: Int,
                                  requestedScheduleRequestRevision: Int,
                                  currentFrom: String,
                                  currentDirectionRevision: Int,
                                  currentScheduleRequestRevision: Int) -> Bool {
    let knownOrigin = requestedFrom == "Larkspur" || requestedFrom == "San Francisco"

    return knownOrigin &&
        requestedFrom == currentFrom &&
        requestedDirectionRevision == currentDirectionRevision &&
        requestedScheduleRequestRevision == currentScheduleRequestRevision
}

func ferryScheduleItemsToPublish<Item>(responseItems: [Item]?,
                                       acceptsResponse: Bool,
                                       requestedFrom: String,
                                       publishedFrom: String?) -> [Item]? {
    guard acceptsResponse else {
        return nil
    }

    if let responseItems = responseItems {
        return responseItems
    }

    if publishedFrom == requestedFrom {
        return nil
    }

    return []
}

func acceptsParsedFerrySchedule(originalRowCount: Int,
                                parsedRowCount: Int) -> Bool {
    guard originalRowCount >= 0,
        parsedRowCount >= 0,
        parsedRowCount <= originalRowCount else {
        return false
    }

    return originalRowCount == 0 || parsedRowCount > 0
}
