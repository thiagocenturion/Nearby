//
//  MapsActionSheetViewModelTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 24/12/20.
//

import UIKit
import Nimble
import Quick
import CoreLocation
import RxCocoa
import RxSwift

@testable import Nearby

final class MapsActionSheetViewModelTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("MapsActionSheetViewModel") {

            describe("init") {

                it("configures the properties correctly") {

                    let coordinate = Coordinate.mock()
                    let application = UIApplication.shared
                    let appleURL = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")
                    let googleURL = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")
                    let wazeURL = URL(string: "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=false")
                    
                    let viewModel = MapsActionSheetViewModel(
                        coordinate: coordinate,
                        application: application
                    )

                    expect(viewModel.coordinate) == coordinate
                    expect(viewModel.application) == application
                    expect(viewModel.appleURL) == appleURL
                    expect(viewModel.googleURL) == googleURL
                    expect(viewModel.wazeURL) == wazeURL
                }
            } // init
            
            describe("setup") {
                
                it("calls canOpenURL correctly") {
                    
                    let coordinate = Coordinate.mock()
                    let applicationStub = UIApplicationStub()
                    applicationStub.canOpenURLResponse = true
                    
                    expect(applicationStub.canOpenURLCalls.isEmpty) == true
                    
                    _ = MapsActionSheetViewModel.mock(coordinate: coordinate, application: applicationStub)
                    
                    expect(applicationStub.canOpenURLCalls.count) == 3
                    
                    expect(applicationStub.canOpenURLCalls[0].url) == URL(
                        string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)"
                    )
                    
                    expect(applicationStub.canOpenURLCalls[1].url) == URL(
                        string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"
                    )
                    
                    expect(applicationStub.canOpenURLCalls[2].url) == URL(
                        string: "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=false"
                    )
                }
                
                it("configures actionsViewModels correctly") {
                    
                    let applicationStub = UIApplicationStub()
                    applicationStub.canOpenURLResponse = true
                    
                    let viewModel = MapsActionSheetViewModel.mock(application: applicationStub)
                    
                    expect(viewModel.actionsViewModels) == [
                        .init(title: "maps_action_sheet_apple".localized),
                        .init(title: "maps_action_sheet_google".localized),
                        .init(title: "maps_action_sheet_waze".localized),
                    ]
                }
                
            } // setup
            
            describe("bind") {
                
                it("creates alert view model correctly async") {
                    
                    let viewModel = MapsActionSheetViewModel.mock()
                    
                    let expectedAlertViewModel = AlertViewModel(
                        title: nil,
                        message: nil,
                        preferredStyle: .actionSheet,
                        actionsViewModels: viewModel.actionsViewModels,
                        cancelActionViewModel: .init(title: "maps_action_sheet_alert_cancel".localized)
                    )
                    
                    var alertViewModel: AlertViewModel?
                    
                    viewModel.alert
                        .subscribe(onNext: { alertViewModel = $0 })
                        .disposed(by: self.disposeBag)
                    
                    waitUntil(timeout: .milliseconds(300)) { done in
                        expect(alertViewModel) == expectedAlertViewModel
                        done()
                    }
                }
            } // bind
        }
    }
}
