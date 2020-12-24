//
//  Endpoint.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 21/12/20.
//

import Foundation

final class Endpoint {
    let path: String
    private(set) var queryItems: [URLQueryItem] = []
    
    init(path: String,
         queryItems: [URLQueryItem]) {
     
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "maps.googleapis.com"
        components.path = "/maps/api/place/" + path
        
        queryItems.append(URLQueryItem(name: "key", value: "AIzaSyCN_YdFh0fgaGB2grcNUTbczPIldqbaAkI"))
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
