//
//  UIApplicationStub.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 28/12/20.
//

#if UNIT_TEST

import UIKit

final class UIApplicationStub: NSObject, UIApplicationType {
    
    // MARK: - Properties
    var canOpenURLCalls: [CanOpenURLCall] = []
    var canOpenURLResponse = true
    
    // MARK: - Initialization
    override init() {}
    
    // MARK: - UIApplicationType
    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalls.append(.init(
            url: url
        ))
        
        return canOpenURLResponse
    }
}

// MARK: - Calls
extension UIApplicationStub {
    
    struct CanOpenURLCall {
        let url: URL
    }
}

#endif
