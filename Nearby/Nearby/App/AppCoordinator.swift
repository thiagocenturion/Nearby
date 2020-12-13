//
//  AppCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    init(window: UIWindow, userDefaults: UserDefaults) {
        self.window = window
        self.userDefaults = userDefaults
    }
}

// MARK: - Coordinator

extension AppCoordinator {
    
    func start() {
        //
    }
}
