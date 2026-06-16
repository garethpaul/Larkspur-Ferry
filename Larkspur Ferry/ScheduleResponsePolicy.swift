func acceptsFerryScheduleResponse(requestedFrom: String,
                                  requestedDirectionRevision: Int,
                                  currentFrom: String,
                                  currentDirectionRevision: Int) -> Bool {
    let knownOrigin = requestedFrom == "Larkspur" || requestedFrom == "San Francisco"

    return knownOrigin &&
        requestedFrom == currentFrom &&
        requestedDirectionRevision == currentDirectionRevision
}
