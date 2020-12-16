//
//  RequestAddressViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import RxSwift
import RxRelay
import RxCocoa
import CoreLocation
import UIKit

final class RequestAddressViewModel {
    // MARK: - Properties
    
    let title: String
    let locationManager: CLLocationManager
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    
    let willUseCurrentLocation = PublishRelay<Void>()
    let willRegisterAddress = PublishRelay<Void>()
    let currentLocationLocation = PublishRelay<Location>()
    let alert = PublishRelay<AlertViewModel>()
    
    // MARK: - Initialization
    
    init(title: String, locationManager: CLLocationManager) {
        self.title = title
        self.locationManager = locationManager
        
        bind()
    }
}

// MARK: - Binding

extension RequestAddressViewModel {
    
    private func bind() {
        let willUseCurrentLocationShared = willUseCurrentLocation.compactMap { [locationManager] in locationManager }.share()
        
        willUseCurrentLocationShared
            .filter { _ in CLLocationManager.authorizationStatus() == .authorizedWhenInUse }
            .bind(to: authorizedBinder)
            .disposed(by: disposeBag)
            
        willUseCurrentLocationShared
            .filter { _ in CLLocationManager.authorizationStatus() == .notDetermined }
            .bind(to: notDeterminedBinder)
            .disposed(by: disposeBag)
            
        willUseCurrentLocationShared
            .filter { _ in CLLocationManager.authorizationStatus() == .denied }
            .map { _ in () }
            .bind(to: deniedBinder)
            .disposed(by: disposeBag)
        
        locationManager.rx.didChangeAuthorization
            .filter { $0.status == .authorizedWhenInUse }
            .map { $0.manager }
            .bind(to: authorizedBinder)
            .disposed(by: disposeBag)
    }
    
    private var authorizedBinder: Binder<CLLocationManager> {
        return Binder(self) { target, locationManager in
            if let location = locationManager.location {
                target.currentLocationLocation.accept(
                    .init(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                )
            }
        }
    }
    
    private var notDeterminedBinder: Binder<CLLocationManager> {
        return Binder(self) { _, locationManager in
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private var deniedBinder: Binder<Void> {
        return Binder(self) { target, _ in
            let alertViewModel = AlertViewModel(
                title: "request_address_denied_title".localized,
                message: "request_address_denied_message".localized,
                preferredStyle: .alert,
                confirmActionViewModel: .init(title: "request_address_denied_confirm".localized),
                cancelActionViewModel: .init(title: "request_address_denied_cancel".localized)
            )
            
            alertViewModel.confirmActionViewModel?.tap
                .subscribe(onNext: {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!,
                        options: [:],
                        completionHandler: nil
                    )
                })
                .disposed(by: target.disposeBag)
            
            target.alert.accept(alertViewModel)
        }
    }
}

#if UNIT_TEST

// MARK: - Equatable

extension RequestAddressViewModel: Equatable {
    
    static func == (lhs: RequestAddressViewModel, rhs: RequestAddressViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.locationManager == rhs.locationManager
    }
}

// MARK: - Mock

extension RequestAddressViewModel {
    
    static func mock(
        title: String = "Location",
        locationManager: CLLocationManager = .init()) -> RequestAddressViewModel {
        
        return .init(
            title: title,
            locationManager: locationManager
        )
    }
}

#endif
