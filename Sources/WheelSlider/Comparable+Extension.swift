//
//  Comparable+Extension.swift
//  WheelSlider
//
//  Created by Nozhan Amiri on 1/4/25.
//

import Foundation

extension Comparable {
    func between(_ lowerBound: Self, _ upperBound: Self) -> Bool {
        lowerBound <= self && self <= upperBound
    }
    
    func between(_ range: ClosedRange<Self>) -> Bool {
        between(range.lowerBound, range.upperBound)
    }
}
