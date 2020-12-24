//
//  PlaceCellViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import Foundation

final class PlaceCellViewModel {
    
    // MARK: - Properties
    let title: String
    var types: [String] = []
    let address: String
    let coordinate: Coordinate
    let rating: String
    let distance: String
    
    // MARK: - Initialization
    init(place: Place, measurementFormatter: MeasurementFormatter) {
        title = place.name
        address = place.vicinity
        coordinate = place.coordinate
        
        if let rating = place.rating {
            self.rating = "\(rating)"
        } else {
            rating = ""
        }
        
        if let distance = place.distance, distance > 0 {
            self.distance = measurementFormatter.string(from: Measurement<UnitLength>(value: distance, unit: .meters))
        } else {
            distance = ""
        }
        
        types = types(with: place.types)
    }
}

// MARK: - Methods
extension PlaceCellViewModel {
    private func types(with placeTypes: [Place.PlaceType]) -> [String] {
        return placeTypes.map {
            switch $0 {
            case .restaurant:
                return "places_restaurant".localized
            case .cafe:
                return "places_cafe".localized
            case .bar:
                return "places_bar".localized
            }
        }
    }
}

#if UNIT_TEST

// MARK: - Mock
extension PlaceCellViewModel {

    public static func mock(
        place: Place = .mock(),
        measurementFormatter: MeasurementFormatter = .init()) -> PlaceCellViewModel {
        
        return PlaceCellViewModel(place: place, measurementFormatter: measurementFormatter)
    }
}

// MARK: - Equatable
extension PlaceCellViewModel: Equatable {

    static func == (lhs: PlaceCellViewModel, rhs: PlaceCellViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.types == rhs.types &&
            lhs.address == rhs.address &&
            lhs.coordinate == rhs.coordinate &&
            lhs.rating == rhs.rating &&
            lhs.distance == rhs.distance
    }
}

#endif
