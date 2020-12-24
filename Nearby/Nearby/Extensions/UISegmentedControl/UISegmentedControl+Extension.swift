//
//  UISegmentedControl+Extension.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import UIKit

extension UISegmentedControl {
    
    func replaceSegments<T: Sequence>(withTitles titles: T) where T.Iterator.Element == String {
        removeAllSegments()

        titles.forEach {
            insertSegment(withTitle: $0, at: numberOfSegments, animated: false)
        }
    }
}
