//
//  ResponseSerializer.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 27.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import XCTest

class ResponseSerializerTests: XCTestCase {
    
    var responseData: Data!
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: ResponseSerializer.self)
        if let url = bundle.url(forResource: "ResponseMock", withExtension: "json") {
            do {
                responseData = try Data(contentsOf:url, options: [])
            } catch let error as NSError {
                XCTFail(error.description)
            }
        } else {
            XCTFail("There is no mock file")
        }
        
    }
    
    func testSyncSerialization() {
        let serializer = ResponseSerializer(data: responseData)
        do {
            let categories = try serializer.serializeSync()
            XCTAssertTrue(categories.count == 12, "Wrong categories count after sync serialization: \(categories.count). Expected 12")
        } catch let error {
            print(error)
            XCTFail("Error during serialization")
        }
    }
    
    func testAsyncSerialization() {
        let exp = expectation(description: "Wait for async serialization")
        
        let serializer = ResponseSerializer(data: responseData)
        serializer.serializeAsync(completion: { (categories: [Category]) in
            XCTAssertTrue(categories.count == 12, "Wrong categories count after async serialization: \(categories.count). Expected 12")
            exp.fulfill()
        }) { (error: Error) in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: { error in
            XCTAssertNil(error, "Oh, we got timeout")
        })
    }
    
}
