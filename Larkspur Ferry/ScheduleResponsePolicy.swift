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
                                       acceptsResponse: Bool) -> [Item]? {
    guard acceptsResponse else {
        return nil
    }

    return responseItems
}
