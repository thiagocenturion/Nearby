//
//  RequestAddressViewModelTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 15/12/20.
//

import Foundation
import Nimble
import Quick
import CoreLocation
import RxCocoa
import RxSwift

@testable import Nearby

final class RequestAddressViewModelTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("RequestAddressViewModel") {

            describe("init") {

                it("configures the properties correctly") {

                    let title = "Location"
                    let locationManager = CLLocationManager()

                    let viewModel = RequestAddressViewModel(
                        title: title,
                        locationManager: locationManager
                    )

                    expect(viewModel.title) == title
                    expect(viewModel.locationManager) === locationManager
                }
            } // init
            
            describe("bind willUseCurrentLocation") {
                
                describe("authorizedBinder") {
                    
                    context("when it triggers `willUseCurrentLocation` with authorization status authorizedWhenInUse") {
                        
                        it("triggers the coordinate to `currentLocationLocation` relay") {
                            
                            let locationManagerStub = LocationManagerStub()
                            let viewModel = RequestAddressViewModel.mock(locationManager: locationManagerStub)
                            var coordinate: Coordinate?
                            let expectedCoordinate = Coordinate.mock()
                            locationManagerStub.setCoordinate = expectedCoordinate
                            
                            viewModel.currentLocationLocation
                                .subscribe(onNext: { coordinate = $0 })
                                .disposed(by: self.disposeBag)
                            
                            expect(coordinate).to(beNil())
                            
                            locationManagerStub.setAuthorizationStatus = .authorizedWhenInUse
                            viewModel.willUseCurrentLocation.accept(())
                            
                            expect(coordinate) == expectedCoordinate
                        }
                    }
                }
                
                describe("notDeterminedBinder") {
                    
                    context("when it triggers `willUseCurrentLocation` with authorization status notDetermined") {
                        
                        it("calls `requestWhenInUseAuthorization` method from location manager") {
                            
                            let locationManagerStub = LocationManagerStub()
                            let viewModel = RequestAddressViewModel.mock(locationManager: locationManagerStub)
                            
                            expect(locationManagerStub.requestWhenInUseAuthorizationCalled) == false
                            
                            locationManagerStub.setAuthorizationStatus = .notDetermined
                            viewModel.willUseCurrentLocation.accept(())
                            
                            expect(locationManagerStub.requestWhenInUseAuthorizationCalled) == true
                        }
                    }
                }

                describe("deniedBinder") {
                    
                    context("when it triggers `willUseCurrentLocation` with authorization status denied") {
                        
                        it("triggers alert view model to alert relay correctly") {
                            
                            let locationManagerStub = LocationManagerStub()
                            let viewModel = RequestAddressViewModel.mock(locationManager: locationManagerStub)
                            var alertViewModel: AlertViewModel?
                            
                            viewModel.alert
                                .subscribe(onNext: { alertViewModel = $0 })
                                .disposed(by: self.disposeBag)
                            
                            expect(alertViewModel).to(beNil())
                            
                            locationManagerStub.setAuthorizationStatus = .denied
                            viewModel.willUseCurrentLocation.accept(())
                            
                            let expectedAlertViewModel = AlertViewModel(
                                title: "request_address_denied_title".localized,
                                message: "request_address_denied_message".localized,
                                preferredStyle: .alert,
                                confirmActionViewModel: .init(title: "request_address_denied_confirm".localized),
                                cancelActionViewModel: .init(title: "request_address_denied_cancel".localized)
                            )
                            
                            expect(alertViewModel) == expectedAlertViewModel
                        }
                    }
                }
            } // bind willUseCurrentLocation
            
            describe("bind locationManager.didChangeAuthorization") {
                
                context("when locationManager triggers `didChangeAuthorization` with authorization status authorizedWhenInUse") {
                    
                    it("triggers the coordinate to `currentLocationLocation` relay") {
                        
                        let locationManagerStub = LocationManagerStub()
                        let didChangeAuthorization = PublishRelay<(LocationManagerType.AuthorizationEvent)>()
                        locationManagerStub.setDidChangeAuthorization = didChangeAuthorization.asObservable()
                        
                        let viewModel = RequestAddressViewModel.mock(locationManager: locationManagerStub)
                        var coordinate: Coordinate?
                        let expectedCoordinate = Coordinate.mock()
                        locationManagerStub.setCoordinate = expectedCoordinate
                        
                        viewModel.currentLocationLocation
                            .subscribe(onNext: { coordinate = $0 })
                            .disposed(by: self.disposeBag)
                        
                        expect(coordinate).to(beNil())
                        
                        didChangeAuthorization.accept(
                            (manager: viewModel.locationManager, status: AuthorizationStatus.authorizedWhenInUse)
                        )
                        
                        expect(coordinate) == expectedCoordinate
                    }
                }
            } // bind locationManager.didChangeAuthorization
        }
    }
}
