//
//  Place.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import Foundation

struct Place {
    
    // MARK: - Inner type
    enum PlaceType: String {
        case restaurant, cafe, bar
    }

    // MARK: - Properties

    let placeID: String
    let name: String
    let iconURL: URL
    let types: [PlaceType]
    let vicinity: String
    let coordinate: Coordinate
}

#if UNIT_TEST

// MARK: - Equatable

extension Place: Equatable {
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.placeID == rhs.placeID &&
            lhs.name == rhs.name &&
            lhs.iconURL == rhs.iconURL &&
            lhs.types == rhs.types &&
            lhs.vicinity == rhs.vicinity &&
            lhs.coordinate == rhs.coordinate
    }
}

// MARK: - Mock

extension Place {

    static func mock(
        placeID: String = "ChIJy3x4bh4xz5QRSd3IC_Dn7xU",
        name: String = "Restaurante Vitória",
        iconURL: URL = URL(string: "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png")!,
        types: [PlaceType] = [.restaurant],
        vicinity: String = "Rua Sebastião da Silva, Itupeva",
        coordinate: Coordinate = .init(latitude: -23.1483946, longitude: -47.03470979999999)) -> Place {
        
        return Place(
            placeID: placeID,
            name: name,
            iconURL: iconURL,
            types: types,
            vicinity: vicinity,
            coordinate: coordinate)
    }
}

#endif
