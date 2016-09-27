//
//  BrochureTests.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 27.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import XCTest
@testable import BonialChallenge

class BrochureTests: XCTestCase {
    
    func testInit() {
        let id = UInt(1)
        let urlString = "https://test.com/file.json"
        let title = "Some title"
        let retailerName = "Retailer name"
        
        let brochure = Brochure(id: id, urlString: urlString, title: title, retailerName: retailerName)
        
        XCTAssertEqual(brochure.id, id, "Wrong brochure id after initialization: \(brochure.id). Expected \(id)")
        XCTAssertEqual(brochure.coverUrlString, urlString, "Wrong brochure coverUrlString after initialization: \(brochure.coverUrlString). Expected \(urlString)")
        XCTAssertEqual(brochure.title, title, "Wrong brochure title after initialization: \(brochure.title). Expected \(title)")
        XCTAssertEqual(brochure.retailerName, retailerName, "Wrong brochure reatailerName after initialization: \(brochure.retailerName). Expected \(retailerName)")
    }
    
    func testEmptyInit() {
        let id = UInt(2)
        
        let brochure = Brochure(id: id, urlString: nil, title: nil, retailerName: nil)
        
        XCTAssertEqual(brochure.id, id, "Wrong brochure id after initialization: \(brochure.id). Expected \(id)")
        XCTAssertEqual(brochure.coverUrlString, "", "Wrong brochure coverUrlString after initialization: \(brochure.coverUrlString). Expected empty string")
        XCTAssertEqual(brochure.title, "", "Wrong brochure title after initialization: \(brochure.title). Expected empty string")
        XCTAssertEqual(brochure.retailerName, "", "Wrong brochure reatailerName after initialization: \(brochure.retailerName). Expected empty string")
    }
    
}
