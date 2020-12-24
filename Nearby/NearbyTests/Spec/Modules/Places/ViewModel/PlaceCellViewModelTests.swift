//
//  PlaceCellViewModelTests.swift
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

final class PlaceCellViewModelTests: QuickSpec {
    
    let disposeBag = DisposeBag()

    override func spec() {

        describe("PlaceCellViewModelTests") {

            describe("init") {

                it("configures the properties correctly") {
                    
                    let place = Place.mock(types: [.restaurant])
                    
                    let title = place.name
                    let address = place.vicinity
                    let coordinate = place.coordinate
                    let rating = "\(place.rating!)"
                    
                    let measurementFormatter = MeasurementFormatter.shortNaturalScaleFormatter(with: Locale.current)
                    let distance = measurementFormatter.string(from: Measurement<UnitLength>(value: place.distance!, unit: .meters))
                    
                    let types = ["places_restaurant".localized]
                    
                    let viewModel = PlaceCellViewModel(place: place, measurementFormatter: measurementFormatter)
                    
                    expect(viewModel.title) == title
                    expect(viewModel.types) == types
                    expect(viewModel.address) == address
                    expect(viewModel.coordinate) == coordinate
                    expect(viewModel.rating) == rating
                    expect(viewModel.distance) == distance
                }
                
                context("when place doesn't have rating") {
                    
                    it("saves empty text") {
                        
                        let place = Place.mock(rating: nil)
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        
                        expect(viewModel.rating).to(beEmpty())
                    }
                }
                
                context("when place doesn't have distance") {
                    
                    it("saves empty text") {
                        
                        let place = Place.mock(distance: nil)
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        
                        expect(viewModel.distance).to(beEmpty())
                    }
                }
                
                context("when place has distance equal to zero") {
                    
                    it("saves empty text") {
                        
                        let place = Place.mock(distance: 0)
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        
                        expect(viewModel.distance).to(beEmpty())
                    }
                }
            } // init
            
            describe("types(with placeTypes: [Place.PlaceType])") {
                
                context("place type equal to restaurant") {
                    
                    it("returns correct text") {
                        
                        let place = Place.mock(types: [.restaurant])
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        expect(viewModel.types) == ["places_restaurant".localized]
                    }
                }
                
                context("place type equal to cafe") {
                    
                    it("returns correct text") {
                        
                        let place = Place.mock(types: [.cafe])
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        expect(viewModel.types) == ["places_cafe".localized]
                    }
                }
                
                context("place type equal to bar") {
                    
                    it("returns correct text") {
                        
                        let place = Place.mock(types: [.bar])
                        let viewModel = PlaceCellViewModel.mock(place: place)
                        expect(viewModel.types) == ["places_bar".localized]
                    }
                }
            } // types(with placeTypes: [Place.PlaceType])
        }
    }
}


