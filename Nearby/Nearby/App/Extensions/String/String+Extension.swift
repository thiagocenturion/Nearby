//
//  String+Extension.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 14/12/20.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
