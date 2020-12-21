//
//  PlaceDetail.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import UIKit

struct PlaceDetail: Encodable {
    
    // MARK: - Properties
    
    let coordinate: Coordinate
    let street: String
    let streetNumber: String
    let neighborhood: String
    let city: String
    let district: String
    let country: String
    let postalCode: String?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case coordinate
        case street = "route"
        case streetNumber = "street_number"
        case neighborhood = "sublocality_level_1"
        case city = "administrative_area_level_2"
        case district = "administrative_area_level_1"
        case country
        case postalCode = "postal_code"
    }
    
    // MARK: - Initialization
    
    init(coordinate: Coordinate,
         street: String,
         streetNumber: String,
         neighborhood: String,
         city: String,
         district: String,
         country: String,
         postalCode: String?) {
        
        self.coordinate = coordinate
        self.street = street
        self.streetNumber = streetNumber
        self.neighborhood = neighborhood
        self.city = city
        self.district = district
        self.country = country
        self.postalCode = postalCode
    }
}

#if UNIT_TEST

// MARK: - Equatable

extension PlaceDetail: Equatable {
    static func == (lhs: PlaceDetail, rhs: PlaceDetail) -> Bool {
        return lhs.coordinate == rhs.coordinate &&
        lhs.street == rhs.street &&
        lhs.streetNumber == rhs.streetNumber &&
        lhs.neighborhood == rhs.neighborhood &&
        lhs.city == rhs.city &&
        lhs.district == rhs.district &&
        lhs.country == rhs.country &&
        lhs.postalCode == rhs.postalCode
    }
    
    
}

// MARK: - Mock

extension PlaceDetail {
    
    static func mock(
        coordinate: Coordinate,
        street: String,
        streetNumber: String,
        neighborhood: String,
        city: String,
        district: String,
        country: String,
        postalCode: String?) -> PlaceDetail {
        
        return .init(
            coordinate: coordinate,
            street: street,
            streetNumber: streetNumber,
            neighborhood: neighborhood,
            city: city,
            district: district,
            country: country,
            postalCode: postalCode
        )
    }
}

#endif
