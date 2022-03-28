//
//  Decilma+Utils.swift
//  bankey
//
//  Created by Bruno Guirra on 27/03/22.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
