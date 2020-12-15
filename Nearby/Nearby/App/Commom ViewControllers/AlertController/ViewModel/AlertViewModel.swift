//
//  AlertViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 15/12/20.
//

import UIKit

final class AlertViewModel {
    
    // MARK: - Properties
    
    let title: String?
    let message: String?
    let preferredStyle: UIAlertController.Style
    let confirmActionViewModel: AlertActionViewModel?
    let cancelActionViewModel: AlertActionViewModel?
    
    // MARK: - Initialization
    
    init(title: String?,
         message: String?,
         preferredStyle: UIAlertController.Style,
         confirmActionViewModel: AlertActionViewModel?,
         cancelActionViewModel: AlertActionViewModel?) {
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.confirmActionViewModel = confirmActionViewModel
        self.cancelActionViewModel = cancelActionViewModel
    }
}
