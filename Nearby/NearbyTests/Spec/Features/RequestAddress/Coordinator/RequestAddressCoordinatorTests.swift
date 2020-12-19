//
//  RequestAddressCoordinatorTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 17/12/20.
//

import Foundation
import Nimble
import Quick
import CoreLocation
import RxCocoa
import RxSwift

@testable import Nearby

final class RequestAddressCoordinatorTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("RequestAddressCoordinatorTests") {

            describe("start") {
                
                it("pushes the correctly view controller") {
                    
                    let navigationControllerStub = UINavigationControllerStub()
                    let coordinator = RequestAddressCoordinator(navigationController: navigationControllerStub)
                    
                    expect(navigationControllerStub.pushCalls.isEmpty) == true
                    
                    _ = coordinator.start()
                    
                    expect(navigationControllerStub.pushCalls.count) == 1
                    
                    let pushCall = navigationControllerStub.pushCalls[0]
                    expect(pushCall.viewController is RequestAddressViewController) == true
                    expect(pushCall.animated) == true
                }
            } // start
            
            describe("RequestAddressViewController") {
                
                describe("alert") {
                    
                    it("triggers the correctly alert to navigationController") {
                        
                        let navigationControllerStub = UINavigationControllerStub()
                        let coordinator = RequestAddressCoordinator(navigationController: navigationControllerStub)
                        let expectedAlertViewModel = AlertViewModel.mock()
                        
                        _ = coordinator.start()
                        
                        expect(navigationControllerStub.calledAlertViewModel).to(beNil())
                        
                        let viewController = navigationControllerStub.pushCalls.first?.viewController
                        let viewModel = (viewController as? RequestAddressViewController)?.viewModel
                        viewModel?.alert.accept(expectedAlertViewModel)
                        
                        expect(navigationControllerStub.calledAlertViewModel) == (expectedAlertViewModel)
                    }
                }
            } // RequestAddressViewController
        }
    }
}
