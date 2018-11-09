//
//  Entry.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Lighthouse

class EntryTests: XCTestCase {
  
    var entry1:Entry!
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        entry1 = Entry()
        entry1.notes = "hellooo"
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
      entry1 = nil
    }

    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      XCTAssertEqual(entry1.notes,"hellooo")
      
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
