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

#if UNIT_TEST

// MARK: - Equatable

extension AlertActionViewModel: Equatable {
    static func == (lhs: AlertActionViewModel, rhs: AlertActionViewModel) -> Bool {
        return lhs.title == rhs.title
    }
}

// MARK: - Mock

extension AlertActionViewModel {
    static func mock(title: String? = "Title Action") -> AlertActionViewModel {
        return .init(title: title)
    }
}

#endif
