//
//  PlacesViewModelTests.swift
//  NearbyTests
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

import Foundation
import Nimble
import Quick
import CoreLocation
import RxCocoa
import RxSwift

@testable import Nearby

final class PlacesViewModelTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("PlacesViewModelTests") {

            describe("init") {

                it("configures the properties correctly") {

                    let segmenteds: [PlacesViewModel.Segmented] = [.init(type: .restaurant, text: "Restaurant")]
                    let placeServices = PlaceServices.mock()
                    let locale = Locale.current
                    let isLoading = true
                    let places = [PlaceCellViewModel.mock()]
                    let coordinate = Coordinate.mock()
                    let radius = 300
                    let selectedType = Place.PlaceType.restaurant

                    let viewModel = PlacesViewModel(
                        segmenteds: segmenteds,
                        placeServices: placeServices,
                        locale: locale,
                        isLoading: isLoading,
                        places: places,
                        coordinate: coordinate,
                        radius: radius,
                        selectedType: selectedType
                    )
                    
                    expect(viewModel.segmenteds) == segmenteds
                    expect(viewModel.placeServices) === placeServices
                    expect(viewModel.locale) == locale
                    expect(viewModel.isLoading.value) == isLoading
                    expect(viewModel.places.value) == places
                    expect(viewModel.coordinate.value) == coordinate
                    expect(viewModel.radius.value) == radius
                    expect(viewModel.selectedType.value) == selectedType
                }
            } // init
            
            describe("fetchPlaces") {
                
                it("calls services correctly") {
                    
                    let placeServicesStub = PlaceServicesStub()
                    let coordinate = Coordinate.mock()
                    let radius = 2500
                    let selectedType = Place.PlaceType.restaurant
                    let locale = Locale.current
                    
                    let viewModel = PlacesViewModel.mock(
                        placeServices: placeServicesStub,
                        locale: locale,
                        coordinate: coordinate,
                        radius: radius,
                        selectedType: selectedType
                    )
                    
                    expect(placeServicesStub.requestPlacesSearchCalls.isEmpty) == true
                    
                    viewModel.fetchPlaces.accept(())
                    
                    expect(placeServicesStub.requestPlacesSearchCalls.count) == 1
                    let call = placeServicesStub.requestPlacesSearchCalls[0]
                    expect(call.coordinate) == coordinate
                    expect(call.radius) == radius
                    expect(call.type) == selectedType
                    expect(call.locale) == locale
                }
                
                context("success") {
                    
                    it("returns the correct response") {
                        
                        let placeServicesStub = PlaceServicesStub()
                        let places: [Place] = [.mock()]
                        placeServicesStub.requestPlacesSearchResponse = .just(places)
                        let locale = Locale.current
                        let viewModel = PlacesViewModel.mock(placeServices: placeServicesStub, locale: locale)
                        
                        let formatter = MeasurementFormatter.shortNaturalScaleFormatter(with: locale)
                        let expectedPlaceViewModels = places.map { PlaceCellViewModel(place: $0, measurementFormatter: formatter) }
                        
                        var placeViewModels: [PlaceCellViewModel] = []
                        viewModel.places
                            .subscribe(onNext: { placeViewModels = $0 })
                            .disposed(by: self.disposeBag)
                        
                        expect(placeViewModels).to(beEmpty())
                        viewModel.fetchPlaces.accept(())
                        expect(placeViewModels) == expectedPlaceViewModels
                    }
                }
                
                context("error") {
                    
                    it("returns the expected error") {
                        
                        let networkingError = NetworkingError.unknown
                        let placeServicesStub = PlaceServicesStub()
                        placeServicesStub.requestPlacesSearchResponse = .error(networkingError)
                        let viewModel = PlacesViewModel.mock(placeServices: placeServicesStub)
                        
                        let expectedAlertViewModel = AlertViewModel(
                            title: "error_message_title".localized,
                            message: networkingError.rawValue,
                            preferredStyle: .alert,
                            actionsViewModels: [.init(title: "error_message_confirm_button".localized)],
                            cancelActionViewModel: .init(title: "request_address_denied_cancel".localized)
                        )
                        
                        var alertViewModel: AlertViewModel?
                        viewModel.alert
                            .subscribe(onNext: { alertViewModel = $0 })
                            .disposed(by: self.disposeBag)
                        
                        expect(alertViewModel).to(beNil())
                        viewModel.fetchPlaces.accept(())
                        expect(alertViewModel) == expectedAlertViewModel
                    }
                }
            } // fetchPlaces
        }
    }
}

