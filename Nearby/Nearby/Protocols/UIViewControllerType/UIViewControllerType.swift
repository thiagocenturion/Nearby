//
//  UIViewControllerType.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 17/12/20.
//

import UIKit

protocol UIViewControllerType: class {
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension UIViewController: UIViewControllerType {}
