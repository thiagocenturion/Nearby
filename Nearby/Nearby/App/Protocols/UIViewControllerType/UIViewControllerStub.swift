//
//  UIViewControllerStub.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 17/12/20.
//

#if UNIT_TEST

import UIKit

final class UIViewControllerStub: UIViewControllerType {
    
    // MARK: - Properties
    
    var presentCalls: [PresentCall] = []
    var dismissCalls: [DismissCall] = []
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - UIViewControllerType
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentCalls.append(.init(
            viewController: viewController,
            animated: animated,
            completion: completion
        ))
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCalls.append(.init(
            animated: animated,
            completion: completion
        ))
    }
}

// MARK: - Call

extension UIViewControllerStub {
    
    struct PresentCall {
        let viewController: UIViewController
        let animated: Bool
        let completion: (() -> Void)?
    }
    
    struct DismissCall {
        let animated: Bool
        let completion: (() -> Void)?
    }
}

#endif
