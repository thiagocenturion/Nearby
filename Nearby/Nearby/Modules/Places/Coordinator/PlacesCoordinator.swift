//
//  PlacesCoordinator.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class PlacesCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Override methods
    
    override func start() -> Observable<Void> {
        return Observable.never()
    }
}
