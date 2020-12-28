//
//  UIApplicationType.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 28/12/20.
//

import UIKit
import RxCocoa

protocol UIApplicationType: NSObject {
    func canOpenURL(_ url: URL) -> Bool
}

extension UIApplication: UIApplicationType {}
