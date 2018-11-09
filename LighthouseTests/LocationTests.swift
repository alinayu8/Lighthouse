//
//  LocationTests.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
@testable import Lighthouse

class LocationTests: XCTestCase {
  
    var location1:Location!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        location1 = Location()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
      location1 = nil
    }

    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(location1.longitude,0.00 )
        XCTAssertEqual(location1.latitude, 0.00)
    }


}
