//
//  MapsActionSheetCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

import UIKit
import RxSwift
import RxCocoa

final class MapsActionSheetCoordinator: BaseCoordinator<URL> {
    
    // MARK: - Properties
    let coordinate: Coordinate
    var viewModel: MapsActionSheetViewModel?
    
    // MARK: - Override methods
    override func start() -> Observable<URL> {
        let viewModel = MapsActionSheetViewModel(
            coordinate: coordinate,
            application: UIApplication.shared
        )
        
        viewModel.alert
            .bind(to: navigationController.alert)
            .disposed(by: disposeBag)
        
        self.viewModel = viewModel
        
        return viewModel.selectedURL
    }
    
    // MARK: - Initialization
    init(coordinate: Coordinate, navigationController: UINavigationControllerType) {
        self.coordinate = coordinate
        super.init(navigationController: navigationController)
    }
}
