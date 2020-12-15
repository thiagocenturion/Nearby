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

@testable import Nearby

final class RequestAddressViewModelTests: QuickSpec {

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
                    expect(viewModel.locationManager) == locationManager
                }
            } // init
            
//            describe("bind") {
//
//                describe("")
//            }
        }
    }
}
