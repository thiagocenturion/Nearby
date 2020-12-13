//
//  RequestAddressViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import RxSwift
import RxRelay
import CoreLocation

final class RequestAddressViewModel {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let locationManager: CLLocationManager
    
    // MARK: - Actions
    
    let isCurrentLocationLoading = BehaviorRelay<Bool>(value: false)
    let willUseCurrentLocation = PublishRelay<Void>()
    let willSearchAddress = PublishRelay<Void>()
    let currentLocationAddress = PublishRelay<Address>()
    
    // MARK: - Initialization
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        
        bind()
    }
}

// MARK: - Binding

extension RequestAddressViewModel {
    
    private func bind() {
        willUseCurrentLocation
            .subscribe(onNext: { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
            })
            .disposed(by: disposeBag)
    }
}
