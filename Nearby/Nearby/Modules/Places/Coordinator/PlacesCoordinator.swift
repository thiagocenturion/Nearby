//
//  PlacesCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class PlacesCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Properties
    let initialCoordinate: Coordinate
    
    // MARK: - Override methods
    override func start() -> Observable<Void> {
        let viewModel = PlacesViewModel(
            restaurantText: "places_restaurant".localized,
            barText: "places_bar".localized,
            cafeText: "places_cafe".localized,
            placeServices: PlaceServices(apiClient: APIClient.shared),
            isLoading: true,
            places: [],
            coordinate: initialCoordinate,
            radius: 500,
            selectedTypes: [.restaurant, .cafe, .bar]
        )
        
        viewModel.selectedPlace
            .bind(to: placeDetailCoordinatorBinder)
            .disposed(by: disposeBag)
        
        viewModel.alert
            .bind(to: navigationController.alert)
            .disposed(by: disposeBag)
        
        let viewController = PlacesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        
        return Observable.never()
    }
    
    // MARK: - Initialization
    init(coordinate: Coordinate, navigationController: UINavigationControllerType) {
        initialCoordinate = coordinate
        super.init(navigationController: navigationController)
    }
}

// MARK: - Coordination
extension PlacesCoordinator {
    
    private var placeDetailCoordinatorBinder: Binder<PlaceViewModel> {
        return Binder(self) { target, placeViewModel in
            // TODO: push register address coordinator
            target.navigationController.pushViewController(UIViewController(), animated: true)
        }
    }
}
