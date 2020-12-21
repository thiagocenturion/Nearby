//
//  NetworkingError.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 21/12/20.
//

import Foundation

enum NetworkingError: Error {
    /// Device is not connect to thet internet
    case noConnection
    
    /// Enconding issue when trying to send data.
    case invalidEncode
    
    /// No data received from the server.
    case noData
    
    /// The server response was invalid (unexpected format).
    case invalidDecode(error: Error)
    
    /// The request was rejected: 400-499.
    case badRequest(error: Error)
    
    /// Encounted a server error.
    case serverError(error: Error)
    
    case serverErrorMessage(message: String?)
    
    /// There was an error parsing the data.
    case parseError(error: Error)
    
    case unknown
}
