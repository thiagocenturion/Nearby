//
//  APIRequest.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 21/12/20.
//

import Foundation
import SwiftyJSON

protocol APIRequestType {
    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var timeout: TimeInterval { get }
}

extension APIRequestType {
    var urlRequest: Result<URLRequest, NetworkingError> {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.timeoutInterval = timeout
        urlRequest.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .get:
            break
            
        case .post(let json), .put(let json):
            guard let data = try? json.rawData() else {
                return .failure(.invalidEncode)
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
        }
        
        return .success(urlRequest)
    }
}

final class APIRequest: APIRequestType {
    
    // MARK: - APIRequestType
    
    let endpoint: Endpoint
    let httpMethod: HTTPMethod
    let timeout: TimeInterval
    
    // MARK: - Initialization
    
    init(endpoint: Endpoint,
         httpMethod: HTTPMethod,
         timeout: TimeInterval) {
        
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.timeout = timeout
    }
}

// MARK: - APIMethod

enum HTTPMethod {
    case get
    case post(json: JSON)
    case put(json: JSON)
    
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        }
    }
}
