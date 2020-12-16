//
//  LocationManagerStub.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 16/12/20.
//

#if UNIT_TEST

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class LocationManagerStub: LocationManagerType {
    
    // MARK: - Properties
    
    var setCoordinate: Coordinate? = .mock()
    var setAuthorizationStatus: AuthorizationStatus = .notDetermined
    var setDidChangeAuthorization: Observable<AuthorizationEvent> = {
        return Observable.just((manager: CLLocationManager() as LocationManagerType, status: AuthorizationStatus.notDetermined))
    }()
    
    private(set) var requestWhenInUseAuthorizationCalled = false
    
    // MARK: - LocationManagerType
    
    var coordinate: Coordinate? {
        return setCoordinate
    }
    
    var authorizationStatus: AuthorizationStatus {
        return setAuthorizationStatus
    }
    
    var didChangeAuthorization: Observable<AuthorizationEvent> {
        return setDidChangeAuthorization
    }
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCalled = true
    }
    
    // MARK: - Initialization
    
    init() {}
}

#endif
