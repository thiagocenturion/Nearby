//
//  UINavigationControllerType.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 17/12/20.
//

import UIKit
import RxCocoa

protocol UINavigationControllerType: UIViewControllerType {
    
    var alert: Binder<AlertViewModel> { get }
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
}

extension UINavigationController: UINavigationControllerType {
    
    var alert: Binder<AlertViewModel> {
        return rx.alert
    }
}
