//
//  UINavigationController+Rx.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 15/12/20.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationController {
    //-----------------------------------------------------------------------------
    // MARK: - Binders
    //-----------------------------------------------------------------------------
    
    var alert: Binder<AlertViewModel> {
        return Binder(base) { target, alertViewModel in
            let alert = UIAlertController(
                title: alertViewModel.title,
                message: alertViewModel.message,
                preferredStyle: alertViewModel.preferredStyle
            )
            
            if let confirmActionViewModel = alertViewModel.confirmActionViewModel {
                let confirmAction = UIAlertAction(
                    title: confirmActionViewModel.title,
                    style: .default,
                    handler: { _ in
                        alertViewModel.confirmActionViewModel?.tap.accept(())
                    }
                )
                
                alert.addAction(confirmAction)
            }
            
            if let cancelActionViewModel = alertViewModel.cancelActionViewModel {
                let cancelAction = UIAlertAction(
                    title: cancelActionViewModel.title,
                    style: .cancel,
                    handler: { _ in
                        alertViewModel.cancelActionViewModel?.tap.accept(())
                    }
                )
                
                alert.addAction(cancelAction)
            }
            
            target.present(alert, animated: true, completion: nil)
        }
    }
}
