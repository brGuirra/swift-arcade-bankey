//
//  CurrencyFormatterTests.swift
//  bankeyUnitTests
//
//  Created by Bruno Guirra on 28/03/22.
//

import XCTest

@testable import bankey

class CurrencyFormatterTests: XCTestCase {

    var formatter: CurrencyFormatter!

    override func setUp() {
        super.setUp()
        
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(929466.23)
        
        XCTAssertEqual(result, "$929,466.23")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0.00)
        
        XCTAssertEqual(result, "$0.00")
    }
}
