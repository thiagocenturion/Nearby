//
//  PlaceServices.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol PlaceServicesType {
    
    var apiClient: APIClientType { get }

    func requestPlacesSearch(
        location: Coordinate,
        radius: Int,
        types: [Place.PlaceType]) -> Single<[Place]>
}

final class PlaceServices: PlaceServicesType {

    // MARK: - Properties

    let apiClient: APIClientType

    // MARK: - Initialization

    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    // MARK: - PlaceWebServicesType

    func requestPlacesSearch(
        location: Coordinate,
        radius: Int,
        types: [Place.PlaceType]) -> Single<[Place]> {
        
        let request = APIRequest(
            endpoint: Endpoint(
                path: "nearbysearch/json",
                queryItems: [
                    URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
                    URLQueryItem(name: "radius", value: "\(radius)"),
                    URLQueryItem(name: "types", value: types.map { $0.rawValue }.joined(separator: ",")),
                    URLQueryItem(name: "language", value: "pt-BR")
                ]
            ),
            httpMethod: .get,
            timeout: 60.0
        )
        
        return apiClient.request(with: request)
            .flatMap { json in
                guard
                    let results = json["results"].array,
                    let places = try? results.map({ try JSONDecoder().decode(Place.self, from: $0.rawData()) })
                else {
                    return .error(NetworkingError.invalidDecode)
                }
                
                return .just(places)
            }
    }
}

#if UNIT_TEST

// MARK: - Mock

extension PlaceServices {

    static func mock(apiClient: APIClientType) -> PlaceServices {
        return PlaceServices(apiClient: apiClient)
    }
}

#endif
