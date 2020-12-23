//
//  PlaceServices.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import Foundation
import RxSwift
import SwiftyJSON
import CoreLocation

protocol PlaceServicesType {
    
    var apiClient: APIClientType { get }

    func requestPlacesSearch(
        coordinate: Coordinate,
        radius: Int,
        type: Place.PlaceType,
        locale: Locale) -> Single<[Place]>
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
        coordinate: Coordinate,
        radius: Int,
        type: Place.PlaceType,
        locale: Locale) -> Single<[Place]> {
        
        let request = APIRequest(
            endpoint: Endpoint(
                path: "nearbysearch/json",
                queryItems: [
                    URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
                    URLQueryItem(name: "radius", value: "\(radius)"),
                    URLQueryItem(name: "types", value: type.rawValue),
                    URLQueryItem(name: "language", value: locale.identifier)
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
                
                let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                places.forEach {
                    let location = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                    $0.distance = currentLocation.distance(from: location)
                }
                
                return .just(
                    places
                        .filter { !$0.types.isEmpty }
                        .sorted(by: { ($0.distance ?? 0) < ($1.distance ?? 0) })
                )
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
