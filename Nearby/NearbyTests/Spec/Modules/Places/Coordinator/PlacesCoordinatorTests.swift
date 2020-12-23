//
//  PlacesCoordinatorTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

import Foundation
import Nimble
import Quick
import RxCocoa
import RxSwift

@testable import Nearby

final class PlacesCoordinatorTests: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {

        describe("PlacesCoordinatorTests") {
            
            describe("init") {

                it("initialize with correct parameters") {

                    let navigationControllerStub = UINavigationControllerStub()
                    let coordinate = Coordinate.mock()
                    let coordinator = PlacesCoordinator(coordinate: coordinate, navigationController: navigationControllerStub)

                    expect(coordinator.initialCoordinate) == coordinate
                    expect(coordinator.navigationController) === navigationControllerStub
                }
            } // init

            describe("start") {

                it("pushes the correctly view controller") {

                    let navigationControllerStub = UINavigationControllerStub()
                    let coordinate = Coordinate.mock()
                    let coordinator = PlacesCoordinator(coordinate: coordinate, navigationController: navigationControllerStub)

                    expect(navigationControllerStub.pushCalls.isEmpty) == true

                    _ = coordinator.start()

                    expect(navigationControllerStub.pushCalls.count) == 1

                    let pushCall = navigationControllerStub.pushCalls[0]
                    expect(pushCall.viewController is PlacesViewController) == true
                    expect(pushCall.animated) == true
                }
            } // start
            
            describe("RequestAddressViewController") {
                
                describe("alert") {
                    
                    it("triggers the correctly alert to navigationController") {
                        
                        let navigationControllerStub = UINavigationControllerStub()
                        let coordinator = PlacesCoordinator.mock(navigationController: navigationControllerStub)
                        let expectedAlertViewModel = AlertViewModel.mock()
                        
                        _ = coordinator.start()
                        
                        expect(navigationControllerStub.calledAlertViewModel).to(beNil())
                        
                        let viewController = navigationControllerStub.pushCalls.first?.viewController
                        let viewModel = (viewController as? PlacesViewController)?.viewModel
                        viewModel?.alert.accept(expectedAlertViewModel)
                        
                        expect(navigationControllerStub.calledAlertViewModel) == (expectedAlertViewModel)
                    }
                }
            } // RequestAddressViewController
        }
    }
}
