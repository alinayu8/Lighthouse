//
//  StatsViewControllerTests.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
@testable import Lighthouse

class AttackOverViewControllerTests: XCTestCase {
  
  var testVC: AttackOverViewController! = AttackOverViewController()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    self.testVC = AttackOverViewController()
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
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

