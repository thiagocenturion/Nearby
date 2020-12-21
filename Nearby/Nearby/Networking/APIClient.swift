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
        return Single.create { single in
            
            guard Reachability.isConnectedToNetwork() else {
                single(.error(NetworkingError.noConnection))
                return Disposables.create()
            }
            
            switch request.urlRequest {
            case .success(let urlRequest):
                let task = self.session.dataTask(with: urlRequest) { data, response, error in
                    
                    if let error = error {
                        single(.error(NetworkingError.serverError(error: error)))
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        single(.error(NetworkingError.noData))
                        return
                    }
                    
                    guard let data = data else {
                        single(.error(NetworkingError.noData))
                        return
                    }
                    
                    guard 200 ..< 300 ~= response.statusCode else {
                        single(.error(NetworkingError.serverErrorMessage(message: String(decoding: data, as: UTF8.self))))
                        return
                    }
                    
                    do {
                        let json = try JSON(data: data)
                        single(.success(json))
                    } catch let decodeError {
                        single(.error(NetworkingError.invalidDecode(error: decodeError)))
                    }
                }
                
                task.resume()
                
            case .failure(let error):
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
