//
//  DatapointTests.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/30/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
@testable import Lighthouse

class DatapointTests: XCTestCase {
    var newDp:Datapoint!
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      super.setUp()
      newDp = Datapoint()
      newDp.value = 12
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        newDp = nil
    }

    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(newDp.value, 12)
    }


}
