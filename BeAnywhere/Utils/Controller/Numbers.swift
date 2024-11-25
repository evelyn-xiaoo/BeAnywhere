//
//  Numbers.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation

func roundToTwoPlace(_ value: Double) -> Double {
    return Double(round(100 * value) / 100)
}
