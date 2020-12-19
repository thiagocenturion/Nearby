//
//  AuthorizationStatus.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 16/12/20.
//

import Foundation

enum AuthorizationStatus: Int32 {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorizedAlways = 3
    case authorizedWhenInUse = 4
}
