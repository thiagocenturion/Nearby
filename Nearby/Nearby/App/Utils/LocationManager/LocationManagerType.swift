//
//  LocationManagerType.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 16/12/20.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationManagerType: class {
    typealias AuthorizationEvent = (manager: LocationManagerType, status: AuthorizationStatus)
    
    var coordinate: Coordinate? { get }
    var authorizationStatus: AuthorizationStatus { get }
    var didChangeAuthorization: Observable<AuthorizationEvent> { get }
    
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationManagerType {
    var coordinate: Coordinate? {
        guard let coordinate = location?.coordinate else { return nil }
        return Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var authorizationStatus: AuthorizationStatus {
        return AuthorizationStatus(rawValue: CLLocationManager.authorizationStatus().rawValue) ?? .notDetermined
    }
    
    var didChangeAuthorization: Observable<AuthorizationEvent> {
        return rx.didChangeAuthorization.map { manager, status in
            return (
                manager: manager as LocationManagerType,
                status: AuthorizationStatus(rawValue: status.rawValue) ?? .notDetermined
            )
        }
    }
}
