//
//  file: API.swift
//  Larkspur Ferry
//
//  Created by Gareth Jones on 12/31/14.
//  Copyright © 2014 gpj. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

private typealias JSONArray = [NSDictionary]
private typealias JSONObject = NSDictionary

// MARK: API class to hold API requests
final class API {
    static let sharedInstance = API()
    private let apiBaseURL = validatedFerryAPIBaseURL(
        Bundle.main.object(forInfoDictionaryKey: ferryAPIBaseURLInfoKey)
    )
    private let requestTimeout: TimeInterval = 10
    
    // MARK: Helper for Ferry
    // Get the location of the ferry
    func getLocation(completion: @escaping (CLLocation?) -> Void) {
        get(endpoint: "ferry/location", parameters: ["t": "1" as AnyObject]) { JSON in
            guard let result = JSON as? JSONObject,
                let latString = result["lat"] as? String,
                let lngString = result["lng"] as? String,
                let lat = latString.toDouble(),
                let lng = lngString.toDouble(),
                isValidFerryCoordinate(latitude: lat, longitude: lng) else {
                    completion(nil)
                    return
            }

            completion(CLLocation(latitude: lat, longitude: lng))
        }
    }
    
    // MARK: Helper for Ferry
    func getTimes(from: String, completion: @escaping ([Ferry]?) -> Void) {
        // Get the ferry from ...
        get(endpoint: "ferry/larkspur", parameters: ["from": from as AnyObject]) { JSON in
            guard let result = JSON as? JSONArray else {
                completion(nil)
                return
            }

            var boats: [Ferry] = []
            for item in result {
                guard let arrive = item["arrive"] as? String,
                    let depart = item["depart"] as? String,
                    let fromLocation = item["from"] as? String,
                    let toLocation = item["to"] as? String else {
                        continue
                }

                let ferryBoat = Ferry(arrive: arrive,
                                      depart: depart,
                                      from: fromLocation,
                                      to: toLocation)
                boats.append(ferryBoat)
            }

            guard acceptsParsedFerrySchedule(
                originalRowCount: result.count,
                parsedRowCount: boats.count
                ) else {
                completion(nil)
                return
            }

            completion(boats)
        }
    }

    // MARK: Helper for Requests
    // Convenience method to perform a GET request on an API endpoint.
    private func get(endpoint: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> Void) {
        request(endpoint: endpoint, encoding: URLEncoding.default, parameters: parameters, completion: completion)
    }
    
    // MARK: Helper for Requests
    // Convenience method to perform a POST request on an API endpoint.
    private func post(endpoint: String, parameters: [String: AnyObject]?, completion: @escaping(AnyObject?) -> Void) {
        request(endpoint: endpoint, encoding: URLEncoding.default, parameters: parameters, completion: completion)
    }
    
    public typealias Parameters = [String: Any]
    
    


    

    
    // MARK: Request helper for Alamofire
    // Perform a request on an API endpoint using Alamofire.
    private func request(endpoint: String, encoding: Alamofire.ParameterEncoding, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> Void) {
        
        let parameterString = parameters?.stringFromHttpParameters() ?? ""
        let querySuffix = parameterString.isEmpty ? "" : "?\(parameterString)"

        guard let apiBaseURL = apiBaseURL,
            let url = URL(string: endpoint + querySuffix, relativeTo: apiBaseURL)?.absoluteURL else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = requestTimeout

        Alamofire.request(urlRequest)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) -> Void in
                let result = response.result
                switch result {
                case .success(let JSONEncoding):
                    completion(JSONEncoding as AnyObject?)
                case .failure:
                    completion(nil)
                }
            }
    }
}
    
