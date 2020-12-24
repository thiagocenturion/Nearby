//
//  MapsActionSheetCoordinatorTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

import UIKit
import Nimble
import Quick
import CoreLocation
import RxCocoa
import RxSwift

@testable import Nearby

final class MapsActionSheetCoordinatorTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("MapsActionSheetCoordinatorTests") {
            
            describe("alert") {
                
                it("triggers the correctly alert to navigationController") {
                    
                    let navigationControllerStub = UINavigationControllerStub()
                    let coordinator = MapsActionSheetCoordinator.mock(navigationController: navigationControllerStub)
                    let expectedAlertViewModel = AlertViewModel.mock()
                    
                    _ = coordinator.start()
                    
                    expect(navigationControllerStub.calledAlertViewModel).to(beNil())
                    
                    coordinator.viewModel?.alert.accept(expectedAlertViewModel)
                    
                    expect(navigationControllerStub.calledAlertViewModel) == (expectedAlertViewModel)
                }
            }
        }
    }
}
