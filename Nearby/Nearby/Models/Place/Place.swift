//
//  Place.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 18/12/20.
//

import Foundation

final class Place: Decodable {
    
    // MARK: - Inner type
    enum PlaceType: String, Decodable {
        case restaurant, cafe, bar
    }

    // MARK: - Properties

    let placeID: String
    let name: String
    let iconURL: URL
    let types: [PlaceType]
    let vicinity: String
    let coordinate: Coordinate
    var rating: Double?
    var distance: Double?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case geometry, name, types, vicinity, rating
        case placeID = "place_id"
        case iconURL = "icon"
    }
    
    private enum GeometryKeys: String, CodingKey {
        case location
    }
    
    // MARK: - Initialization
    
    init(placeID: String,
         name: String,
         iconURL: URL,
         types: [PlaceType],
         vicinity: String,
         coordinate: Coordinate,
         rating: Double?,
         distance: Double?) {
        
        self.placeID = placeID
        self.name = name
        self.iconURL = iconURL
        self.types = types
        self.vicinity = vicinity
        self.coordinate = coordinate
        self.rating = rating
        self.distance = distance
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.placeID = try container.decode(String.self, forKey: .placeID)
        self.name = try container.decode(String.self, forKey: .name)
        
        let iconUrlString = try container.decode(String.self, forKey: .iconURL)
        
        guard let iconURL = URL(string: iconUrlString) else { throw NetworkingError.invalidDecode }
        self.iconURL = iconURL
        
        let types = try container.decode([String].self, forKey: .types)
        self.types = types.compactMap { PlaceType(rawValue: $0) }
        
        self.vicinity = try container.decode(String.self, forKey: .vicinity)
        
        let geometryContainer = try container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        self.coordinate = try geometryContainer.decode(Coordinate.self, forKey: .location)
        
        if let rating = try? container.decode(Double.self, forKey: .rating) {
            self.rating = rating
        }
    }
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
            lhs.coordinate == rhs.coordinate &&
            lhs.rating == rhs.rating &&
            lhs.distance == rhs.distance
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
        coordinate: Coordinate = .init(latitude: -23.1483946, longitude: -47.03470979999999),
        rating: Double = 4.8,
        distance: Double? = 300) -> Place {
        
        return Place(
            placeID: placeID,
            name: name,
            iconURL: iconURL,
            types: types,
            vicinity: vicinity,
            coordinate: coordinate,
            rating: rating,
            distance: distance
        )
    }
}

#endif
