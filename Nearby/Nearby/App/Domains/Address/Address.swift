//
//  Address.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 12/12/20.
//

import UIKit

struct Address: Codable {
    
    // MARK: - Properties
    
    let location: Location
    let street: String
    let streetNumber: String
    let neighborhood: String
    let city: String
    let district: String
    let country: String
    let postalCode: String?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case location
        case street = "route"
        case streetNumber = "street_number"
        case neighborhood = "sublocality_level_1"
        case city = "administrative_area_level_2"
        case district = "administrative_area_level_1"
        case country
        case postalCode = "postal_code"
    }
    
    // MARK: - Initialization
    
    init(location: Location,
         street: String,
         streetNumber: String,
         neighborhood: String,
         city: String,
         district: String,
         country: String,
         postalCode: String?) {
        
        self.location = location
        self.street = street
        self.streetNumber = streetNumber
        self.neighborhood = neighborhood
        self.city = city
        self.district = district
        self.country = country
        self.postalCode = postalCode
    }
}
