//
//  ContactTests.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/30/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
@testable import Lighthouse

class ContactTests: XCTestCase {
  var contact1:Contact!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      super.setUp()
      
      contact1 = Contact()
      contact1.name = "BluefootedBooby"
      contact1.number = "1112223333"
      
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
      contact1 = nil
    }

    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      XCTAssertEqual(contact1.name,"BluefootedBooby")
      XCTAssertEqual(contact1.number,"1112223333")
    }

  

}
