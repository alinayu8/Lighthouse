//
//  EntryViewControllerTests.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
import Charts
@testable import Lighthouse
class EntryViewControllerTests: XCTestCase {
  
    var testVC: EntryViewController! = EntryViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      super.setUp()
      self.testVC = EntryViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
    }

    func testlineChartUpdate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      let entry1 = ChartDataEntry(x: 1.0, y: Double(3))
      let entry2 = ChartDataEntry(x: 2.0, y: Double(5))
      let entry3 = ChartDataEntry(x: 3.0, y: Double(2))
      let dataSet = LineChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
      let data = LineChartData(dataSets: [dataSet])
      XCTAssert(data != nil)
      
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
