//
//  UIViewController+Rx.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        let event = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: event)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let event = methodInvoked(#selector(Base.viewWillAppear)).map { args in (args.first as? Bool) ?? false }
        return ControlEvent(events: event)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let event = methodInvoked(#selector(Base.viewDidAppear)).map { args in (args.first as? Bool) ?? false }
        return ControlEvent(events: event)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let event = methodInvoked(#selector(Base.viewWillDisappear)).map { args in (args.first as? Bool) ?? false }
        return ControlEvent(events: event)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let event = methodInvoked(#selector(Base.viewDidDisappear)).map { args in (args.first as? Bool) ?? false }
        return ControlEvent(events: event)
    }
}
