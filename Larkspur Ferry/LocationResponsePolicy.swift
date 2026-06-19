func acceptsFerryLocationResponse(requestedRevision: Int,
                                  currentRevision: Int) -> Bool {
    return requestedRevision == currentRevision
}

func isValidFerryCoordinate(latitude: Double, longitude: Double) -> Bool {
    guard latitude.isFinite && longitude.isFinite else {
        return false
    }

    return (-90.0...90.0).contains(latitude) &&
        (-180.0...180.0).contains(longitude)
}
