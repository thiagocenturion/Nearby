//
//  APIClient.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 21/12/20.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

protocol APIClientType {
    var session: URLSession { get }
    
    func request(with request: APIRequestType) -> Single<JSON>
}

final class APIClient: APIClientType {
    
    // MARK: - Shared
    
    static let shared: APIClientType = APIClient(session: URLSession.shared)
    
    // MARK: - APIClientType
    
    let session: URLSession
    
    // MARK: - Initialization
    
    init(session: URLSession) {
        self.session = session
    }
}

// MARK: - APIClientType

extension APIClient {
    
    func request(with request: APIRequestType) -> Single<JSON> {
        
        switch request.urlRequest {
        case .success(let urlRequest):
            return self.session.rx.dataTask(with: urlRequest)
                .flatMap { response, data in
                    guard let json = try? JSON(data: data) else {
                        return .error(NetworkingError.invalidDecode)
                    }
                    
                    return .just(json)
                }
            
        case .failure(let error):
            return .error(error)
        }
    }
}
