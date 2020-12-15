//
//  AlertActionViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 15/12/20.
//

import UIKit
import RxRelay

final class AlertActionViewModel {
    
    // MARK: - Properties
    
    let title: String?
    let tap = PublishRelay<Void>()
    
    // MARK: -  Initialization
    
    init(title: String?) {
        self.title = title
    }
}
