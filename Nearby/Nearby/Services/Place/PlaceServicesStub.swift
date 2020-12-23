//
//  PlaceServicesStub.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

#if UNIT_TEST

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

final class PlaceServicesStub: PlaceServicesType {

    // MARK: - Stub
    var requestPlacesSearchCalls: [RequestPlacesSearchCall] = []
    var requestPlacesSearchReturn: [Place] = []
    
    // MARK: - Spy
    enum ResponseType {
        case none
        case success
        case error(NetworkingError)
    }
    
    private let responseType: ResponseType
    
    // MARK: - Initialization
    init(responseType: ResponseType) {
        self.responseType = responseType
    }

    // MARK: - PlaceServicesType
    var apiClient: APIClientType = APIClient(session: URLSession.shared)
    
    func requestPlacesSearch(
        coordinate: Coordinate,
        radius: Int,
        type: Place.PlaceType,
        locale: Locale) -> Single<[Place]> {
        
        requestPlacesSearchCalls.append(.init(
            coordinate: coordinate,
            radius: radius,
            type: type,
            locale: locale
        ))
        
        switch responseType {
        case .none:
            return .never()
        case .success:
            return .just(requestPlacesSearchReturn)
        case .error(let error):
            return .error(error)
        }
    }
}

// MARK: - Calls
extension PlaceServicesStub {

    struct RequestPlacesSearchCall {
        let coordinate: Coordinate
        let radius: Int
        let type: Place.PlaceType
        let locale: Locale
    }
}

#endif
