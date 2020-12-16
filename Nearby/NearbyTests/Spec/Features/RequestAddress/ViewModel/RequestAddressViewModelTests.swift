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
            
            describe("bind") {

                describe("deniedBinder") {
                    
                    context("when it triggers `willUseCurrentLocation` with authorization status denied") {
                        
                        it("emitis alert view model to alert relay correctly") {
                            
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
            }
        }
    }
}
