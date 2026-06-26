import Foundation

let ferryAPIBaseURLInfoKey = "FerryAPIBaseURL"

func validatedFerryAPIBaseURL(_ rawValue: Any?) -> URL? {
    guard let configuredValue = rawValue as? String else {
        return nil
    }

    let trimmedValue = configuredValue.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedValue.isEmpty,
        var components = URLComponents(string: trimmedValue),
        components.scheme?.lowercased() == "https",
        let host = components.host,
        !host.isEmpty,
        components.user == nil,
        components.password == nil,
        components.query == nil,
        components.fragment == nil else {
            return nil
    }

    components.scheme = "https"
    if !components.path.hasSuffix("/") {
        components.path += "/"
    }

    return components.url
}
