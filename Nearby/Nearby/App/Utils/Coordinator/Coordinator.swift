//
//  Coordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import Foundation

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}
