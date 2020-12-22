//
//  PlaceViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import Foundation

struct PlaceViewModel {
    
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
