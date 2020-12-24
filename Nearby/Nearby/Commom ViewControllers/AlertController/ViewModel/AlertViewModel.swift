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
    let actionsViewModels: [AlertActionViewModel]
    let cancelActionViewModel: AlertActionViewModel?
    
    // MARK: - Initialization
    
    init(title: String?,
         message: String?,
         preferredStyle: UIAlertController.Style,
         actionsViewModels: [AlertActionViewModel],
         cancelActionViewModel: AlertActionViewModel?) {
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.actionsViewModels = actionsViewModels
        self.cancelActionViewModel = cancelActionViewModel
    }
}

#if UNIT_TEST

// MARK: - Equatable

extension AlertViewModel: Equatable {
    static func == (lhs: AlertViewModel, rhs: AlertViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.message == rhs.message &&
            lhs.preferredStyle == rhs.preferredStyle &&
            lhs.actionsViewModels == rhs.actionsViewModels &&
            lhs.cancelActionViewModel == rhs.cancelActionViewModel
    }
}

// MARK: - Mock

extension AlertViewModel {
    
    static func mock(
        title: String? = "Title",
        message: String? = "Message",
        preferredStyle: UIAlertController.Style = .alert,
        actionsViewModels: [AlertActionViewModel] = [.mock()],
        cancelActionViewModel: AlertActionViewModel? = .mock()) -> AlertViewModel {
        
        return .init(
            title: title,
            message: message,
            preferredStyle: preferredStyle,
            actionsViewModels: actionsViewModels,
            cancelActionViewModel: cancelActionViewModel)
    }
}

#endif
