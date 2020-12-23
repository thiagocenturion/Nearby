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
            segmenteds: [
                (type: .restaurant, text: "places_restaurant".localized),
                (type: .cafe, text: "places_cafe".localized),
                (type: .bar, text: "places_bar".localized)
            ],
            placeServices: PlaceServices(apiClient: APIClient.shared),
            locale: Locale.current,
            isLoading: true,
            places: [],
            coordinate: initialCoordinate,
            radius: 2500,
            selectedType: .restaurant
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
    
    private var placeDetailCoordinatorBinder: Binder<PlaceCellViewModel> {
        return Binder(self) { target, placeViewModel in
            // TODO: push register address coordinator
            target.navigationController.pushViewController(UIViewController(), animated: true)
        }
    }
}
