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
    private let apiBaseURL = "https://requestlabs.appspot.com/"
    
    // MARK: Helper for Ferry
    // Get the location of the ferry
    func getLocation(completion: @escaping (CLLocation) -> Void) {
        get(endpoint: "ferry/location", parameters: ["t": "1" as AnyObject]) { JSON in
            if let result = JSON as? JSONObject {
                let lat = result["lat"] as! String
                let lng = result["lng"] as! String
                let location = CLLocation(latitude: lat.toDouble()!, longitude: lng.toDouble()!)
                completion(location)
            }
        }
    }
    
    // MARK: Helper for Ferry
    func getTimes(from: String, completion: @escaping ([Ferry]) -> Void) {
        // Get the ferry from ...
        get(endpoint: "ferry/larkspur", parameters: ["from": from as AnyObject]) { JSON in
            
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
        
        let parameterString = parameters!.stringFromHttpParameters()
        //let URL = Foundation.URL(string: apiBaseURL + endpoint + "?\(parameterString)")
        //let URLRequest = NSMutableURLRequest(url: URL!)
        //URLRequest.httpMethod = "GET"
        let url = URL(string: apiBaseURL + endpoint + "?\(parameterString)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        
        do {
            //let request = try encoding.encode(URLRequest as! URLRequestConvertible, with: nil)
            Alamofire.request(urlRequest).responseJSON { (response) -> Void in
                let result = response.result
                switch result {
                case .success(let JSONEncoding):
                    completion(JSONEncoding as AnyObject?)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(nil)
                }
            }
        } catch {
            print("wow something went wrong")
        }
        //
        //_ = Alamofire.request(apiBaseURL + endpoint, parameters: parameters, encoding: URLEncoding(destination: .queryString)).responseJSON { (response) -> Void in
        //    let result = response.result
        //    switch result {
        //    case .success(let JSONEncoding):
        //        completion(JSONEncoding as AnyObject?)
        //    case .failure(let error):
        //        print("Request failed with error: \(error)")
        //        completion(nil)
        //    }
        //    }
    }
        //let request = encoding.encode(URLRequest as! URLRequestConvertible, with: nil).0
        
}
    
