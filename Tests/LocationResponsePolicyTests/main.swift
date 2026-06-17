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

private func expectCoordinate(_ latitude: Double,
                              _ longitude: Double,
                              _ expected: Bool,
                              _ message: String) {
    let actual = isValidFerryCoordinate(latitude: latitude, longitude: longitude)

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

expectCoordinate(37.79984, -122.38921, true, "normal ferry coordinate")
expectCoordinate(-90.0, -180.0, true, "minimum coordinate boundaries")
expectCoordinate(90.0, 180.0, true, "maximum coordinate boundaries")
expectCoordinate(-90.0001, 0.0, false, "latitude below minimum")
expectCoordinate(90.0001, 0.0, false, "latitude above maximum")
expectCoordinate(0.0, -180.0001, false, "longitude below minimum")
expectCoordinate(0.0, 180.0001, false, "longitude above maximum")
expectCoordinate(Double.nan, 0.0, false, "NaN latitude")
expectCoordinate(0.0, Double.nan, false, "NaN longitude")
expectCoordinate(Double.infinity, 0.0, false, "infinite latitude")
expectCoordinate(0.0, -Double.infinity, false, "infinite longitude")

if failureCount > 0 {
    fatalError("LocationResponsePolicy behavioral tests failed: \(failureCount)")
}

print("LocationResponsePolicy behavioral tests passed")
