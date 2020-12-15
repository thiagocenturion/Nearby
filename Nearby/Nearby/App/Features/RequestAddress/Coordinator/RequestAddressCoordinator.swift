//
//  RequestAddressCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import CoreLocation

final class RequestAddressCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Override methods
    
    override func start() -> Observable<Void> {
        let viewModel = RequestAddressViewModel(
            title: "request_address_title".localized,
            locationManager: CLLocationManager()
        )
        
        viewModel.willRegisterAddress
            .bind(to: registerAddressCoordinatorBinder)
            .disposed(by: disposeBag)
        
        viewModel.currentLocationLocation
            .bind(to: placesCoordinatorBinder)
            .disposed(by: disposeBag)
        
        viewModel.alert
            .bind(to: navigationController.rx.alert)
            .disposed(by: disposeBag)
        
        let viewController = RequestAddressViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.never()
    }
}

// MARK: - Coordination

extension RequestAddressCoordinator {
    
    private var registerAddressCoordinatorBinder: Binder<Void> {
        return Binder(self) { target, _ in
            // TODO: push register address coordinator
            target.navigationController.pushViewController(UIViewController(), animated: true)
        }
    }
    
    private var placesCoordinatorBinder: Binder<Location> {
        return Binder(self) { target, location in
            // TODO: push places coordinator
            target.navigationController.pushViewController(UIViewController(), animated: true)
        }
    }
}
