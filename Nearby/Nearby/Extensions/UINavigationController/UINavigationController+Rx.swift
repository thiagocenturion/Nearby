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
            alert.view.tintColor = #colorLiteral(red: 0.01473112591, green: 0.8120005727, blue: 0.8805894256, alpha: 1)
            
            alertViewModel.actionsViewModels.forEach { actionViewModel in
                let action = UIAlertAction(
                    title: actionViewModel.title,
                    style: .default,
                    handler: { _ in
                        actionViewModel.tap.accept(())
                    }
                )
                
                alert.addAction(action)
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
