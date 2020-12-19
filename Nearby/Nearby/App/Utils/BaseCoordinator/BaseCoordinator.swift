//
//  BaseCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import UIKit
import RxSwift

class BaseCoordinator<ResultType> {
    
    // MARK: - Properties
    
    typealias CoordinationResult = ResultType
    
    let navigationController: UINavigationControllerType
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationControllerType) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods for Override
    
    func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented by the child.")
    }
}

// MARK: - Methods

extension BaseCoordinator {
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
}
