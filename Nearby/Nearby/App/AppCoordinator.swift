//
//  AppCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    // MARK: - Initialization
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        
        super.init(navigationController: navigationController)
    }
    
    // MARK: - Override methods
    
    override func start() -> Observable<Void> {
        let coordinator = RequestAddressCoordinator(navigationController: navigationController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: coordinator)
    }
}
