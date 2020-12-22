//
//  Coordinate.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 16/12/20.
//

import Foundation

struct Coordinate: Codable {
    
    // MARK: - Properties
    
    let latitude: Double
    let longitude: Double
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    // MARK: - Initialization
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

#if UNIT_TEST

// MARK: - Equatable

extension Coordinate: Equatable {
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

// MARK: - Mock

extension Coordinate {
    
    static func mock(latitude: Double = -23.14905, longitude: Double = -47.03540) -> Coordinate {
        return .init(latitude: latitude, longitude: longitude)
    }
}

#endif
