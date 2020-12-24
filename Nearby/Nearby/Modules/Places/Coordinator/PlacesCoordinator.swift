//
//  PlacesCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import UIKit
import RxSwift
import RxCocoa

final class PlacesCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Properties
    let initialCoordinate: Coordinate
    
    // MARK: - Override methods
    override func start() -> Observable<Void> {
        let viewModel = PlacesViewModel(
            segmenteds: [
                .init(type: .restaurant, text: "places_restaurant".localized),
                .init(type: .cafe, text: "places_cafe".localized),
                .init(type: .bar, text: "places_bar".localized)
            ],
            placeServices: PlaceServices(apiClient: APIClient.shared),
            locale: Locale.current,
            isLoading: true,
            places: [],
            coordinate: initialCoordinate,
            radius: 2500,
            selectedType: .restaurant
        )
        
        viewModel.alert
            .bind(to: navigationController.alert)
            .disposed(by: disposeBag)
        
        viewModel.selectedPlace
            .map { $0.coordinate }
            .bind(to: openMapsActionSheet)
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

// MARK: - Binding
extension PlacesCoordinator {
    
    private var openMapsActionSheet: Binder<Coordinate> {
        return Binder(self) { target, coordinate in
            
            let coordinator = MapsActionSheetCoordinator(
                coordinate: coordinate,
                navigationController: target.navigationController
            )
            
            target.coordinate(to: coordinator)
                .subscribe(onNext: { url in
                    UIApplication.shared.open(
                        url,
                        options: [:],
                        completionHandler: nil
                    )
                })
                .disposed(by: target.disposeBag)
        }
    }
}


#if UNIT_TEST

// MARK: - Mock
extension PlacesCoordinator {
    
    static func mock(
        coordinate: Coordinate = .mock(),
        navigationController: UINavigationControllerType = UINavigationControllerStub()) -> PlacesCoordinator {
        
        return .init(coordinate: coordinate, navigationController: navigationController)
    }
}

#endif
