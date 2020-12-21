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

    func requestPlacesSearch(
        location: Coordinate,
        radius: Int,
        types: [Place.PlaceType]) -> Single<[Place]>
}

final class PlaceServices: PlaceServicesType {

    // MARK: - Properties

    let apiKey: String
    let session: URLSession

    // MARK: - Initialization

    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    // MARK: - PlaceWebServicesType

    func requestPlacesSearch(
        location: Coordinate,
        radius: Int,
        types: [Place.PlaceType]) -> Single<[Place]> {
    
        let params: [String: Any] = [
            "param": param
        ]

        return sessionManager.request(
            endpoint: ClientEndpoint(.login),
            httpMethod: .post(.init(
                params: params,
                encoding: .json,
                encryption: .init(keyToEncrypt: "Data"),
                shouldUseGZIP: true
            ))
        ).flatMap { json in
            do {
                let model = try JSONDecoder().decode(Model.self, from: json.rawData())
                return .just(model)
            } catch {
                return .error(NeonServerError.invalidResponse)
            }
        }
    }
}

#if UNIT_TEST

// MARK: - Mock

extension PlaceServices {

    static func mock(
        apiKey: String = "BZsbOqPW...",
        session: URLSession = .shared) -> PlaceServices {

        return PlaceServices(
            apiKey: apiKey,
            session: session
        )
    }
}

#endif
