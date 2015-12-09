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

final class API {
    static let sharedInstance = API()
    private let apiBaseURL = "https://requestlabs.appspot.com/"
    
    // MARK: Helper for Ferry
    // Get the location of the ferry
    func getLocation(completion: CLLocation -> Void) {
        get("ferry/location", parameters: ["t": "1"]) { JSON in
            if let result = JSON as? JSONObject {
                let lat = result["lat"] as! String
                let lng = result["lng"] as! String
                let location = CLLocation(latitude: lat.toDouble()!, longitude: lng.toDouble()!)
                completion(location)
            }
        }
    }
    
    // MARK: Helper for Ferry
    func getTimes(from: String, completion: [Ferry] -> Void) {
        // Get the ferry from ...
        get("ferry/larkspur", parameters: ["from": from]) { JSON in
            
            var boats: [Ferry] = []
            if let result = JSON as? JSONArray {
                for item in result {
                    let ferryBoat: Ferry = Ferry(arrive: item["arrive"] as! String!,
                                                 depart: item["depart"] as! String,
                                                 from: item["from"] as! String,
                                                 to: item["to"] as! String)
                    boats.append(ferryBoat)
                }
                completion(boats)
            }
        }
    }

    // MARK: Helper for Requests
    // Convenience method to perform a GET request on an API endpoint.
    private func get(endpoint: String, parameters: [String: AnyObject]?, completion: AnyObject? -> Void) {
        request(endpoint, method: "GET", encoding: .JSON, parameters: parameters, completion: completion)
    }
    
    // MARK: Helper for Requests
    // Convenience method to perform a POST request on an API endpoint.
    private func post(endpoint: String, parameters: [String: AnyObject]?, completion: AnyObject? -> Void) {
        request(endpoint, method: "POST", encoding: .JSON, parameters: parameters, completion: completion)
    }
    
    // MARK: Request helper for Alamofire
    // Perform a request on an API endpoint using Alamofire.
    private func request(endpoint: String, method: String, encoding: Alamofire.ParameterEncoding, parameters: [String: AnyObject]?, completion: AnyObject? -> Void) {
        let parameterString = parameters!.stringFromHttpParameters()
        let URL = NSURL(string: apiBaseURL + endpoint + "?\(parameterString)")
        let URLRequest = NSMutableURLRequest(URL: URL!)
        URLRequest.HTTPMethod = method

        let request = encoding.encode(URLRequest, parameters: nil).0

        //print("Starting \(method) \(URL) (\(parameters ?? [:]))")
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            if let JSON = response.result.value {
                print(JSON)
            }
            let result = response.result
            switch result {
            case .Success(let JSON):
                completion(JSON)
            case .Failure(let error):
                print("Request failed with error: \(error)")
                completion(nil)
            }
            
        }
    }
    
}