//
//  HurryPorter_iOSTests.swift
//  HurryPorter_iOS
//
//  Created by 葉建胤 on 2/7/16.
//  Copyright © 2016 Seachaos. All rights reserved.
//

import XCTest

class HurryPorter_iOSTests_Swift: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testJSONConvert_swift(){
        // test dict
        var exceptString = "{\"subDict\":{\"test\":\"AABBCC\",\"IntValue\":3,\"array\":[3,5,6,7]},\"name\":\"Good\",\"array\":[1,3,5,6,8,9]}"
        var dict = [
            "name":"Good",
            "array":[1,3,5,6,8,9],
            "subDict":[
                "test":"AABBCC",
                "IntValue":3,
                "array":[3,5,6,7]
            ]
        ]
        var result = HurryPorter.jsonToString(dict)
        let exceptDict = HurryPorter.stringToDict(result)
        XCTAssertTrue(exceptDict == NSDictionary(dictionary: dict))
        
        // test dict different
        dict = [
            "name":"Goodx",
            "subDict":[
                "test":"AABBCC",
                "IntValue":3,
                "array":[3,5,6,7]
            ]
        ]
        XCTAssertFalse(exceptDict == NSDictionary(dictionary: dict))
        
        // test array
        exceptString = "[1,3,5,7,9]"
        let array = [1,3,5,7,9]
        result = HurryPorter.jsonToString(array)
        XCTAssertTrue(exceptString==result)
    }
}
