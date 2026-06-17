func acceptsFerryLocationResponse(requestedRevision: Int,
                                  currentRevision: Int) -> Bool {
    return requestedRevision == currentRevision
}
