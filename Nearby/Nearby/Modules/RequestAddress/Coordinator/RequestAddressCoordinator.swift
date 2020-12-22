//
//  RequestAddressCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class RequestAddressCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Override methods
    override func start() -> Observable<Void> {
        let viewModel = RequestAddressViewModel(
            title: "request_address_title".localized,
            description: "request_address_description".localized,
            currentLocationText: "request_address_current_location".localized,
            registerAddressText: "request_address_register_address".localized,
            locationManager: CLLocationManager()
        )
        
        viewModel.willRegisterAddress
            .bind(to: registerAddressCoordinatorBinder)
            .disposed(by: disposeBag)
        
        viewModel.currentLocation
            .bind(to: placesCoordinatorBinder)
            .disposed(by: disposeBag)
        
        viewModel.alert
            .bind(to: navigationController.alert)
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
    
    private var placesCoordinatorBinder: Binder<Coordinate> {
        return Binder(self) { target, coordinate in
            
            let coordinator = PlacesCoordinator(coordinate: coordinate, navigationController: target.navigationController)
            target.coordinate(to: coordinator)
                .subscribe()
                .disposed(by: target.disposeBag)
        }
    }
}
