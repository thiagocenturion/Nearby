//
//  PlaceCellViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import Foundation

struct PlaceCellViewModel {
    
    // MARK: - Properties
    let title: String
    let types: [Place.PlaceType]
    let address: String
    let coordinate: Coordinate
    
    // MARK: - Initialization
    init(place: Place) {
        title = place.name
        types = place.types
        address = place.vicinity
        coordinate = place.coordinate
    }
}

#if UNIT_TEST

//-----------------------------------------------------------------------------
// MARK: - Mock
//-----------------------------------------------------------------------------

extension PlaceCellViewModel {

    public static func mock(example: String) -> PlaceCellViewModel {
        return PlaceCellViewModel(example: example)
    }
}

//-----------------------------------------------------------------------------
// MARK: - Equatable
//-----------------------------------------------------------------------------

extension PlaceCellViewModel: Equatable {

    public static func == (lhs: PlaceCellViewModel, rhs: PlaceCellViewModel) -> Bool {
        return lhs.example.value == rhs.example.value
    }
}

#endif
