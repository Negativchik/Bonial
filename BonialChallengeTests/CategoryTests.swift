//
//  CategoryTests.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 27.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import XCTest
@testable import BonialChallenge

class CategoryTests: XCTestCase {
    
    func testInit() {
        let id = UInt(1)
        let urlString = "https://test.com/file.json"
        let name = "Name"
        
        let category = Category(id: id, urlString: urlString, name: name)
        
        XCTAssertEqual(category.id, id, "Wrong brochure id after initialization: \(category.id). Expected \(id)")
        XCTAssertEqual(category.urlString, urlString, "Wrong brochure coverUrlString after initialization: \(category.urlString). Expected \(urlString)")
        XCTAssertEqual(category.name, name, "Wrong brochure title after initialization: \(category.name). Expected \(name)")
    }
    
    func testEmptyInit() {
        let id = UInt(1)
        
        let category = Category(id: id, urlString: nil, name: nil)
        
        XCTAssertEqual(category.id, id, "Wrong brochure id after initialization: \(category.id). Expected \(id)")
        XCTAssertEqual(category.urlString, "", "Wrong brochure coverUrlString after initialization: \(category.urlString). Expected empty String")
        XCTAssertEqual(category.name, "", "Wrong brochure title after initialization: \(category.name). Expected empty String")
    }
    
    func testAppendingBrochure() {
        let category = Category(id: UInt(1), urlString: nil, name: nil)
        
        XCTAssertTrue(category.brochures.count == 0, "Category contains \(category.brochures.count) brochures. Expected 0")
        
        let brochure = Brochure(id: UInt(1), urlString: nil, title: nil, retailerName: nil)
        
        category.append(brochure: brochure)
        
        XCTAssertTrue(category.brochures.count == 1, "Category contains \(category.brochures.count) brochures. Expected 1")
    }
    
}
