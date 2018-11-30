//
//  HomeViewController.swift
//  LighthouseTests
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import XCTest
import CoreData
@testable import Lighthouse
class HomeViewControllerTests: XCTestCase {
  
  var testVC: HomeViewController! = HomeViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.testVC = HomeViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func saveEntryTest() {
        let entry = Entry()
        entry.startTime = Date() //set start time of attack, time zone
        entry.latitude = 0
        entry.longitude = 0
        testVC.saveEntry(entry: entry)
        
        // assertions
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: true)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let date = data.value(forKey: "start_time") as! Date
                let lat = data.value(forKey: "latitude") as! Double
                let long = data.value(forKey: "longitude") as! Double
                XCTAssertEqual(date,entry.startTime)
                XCTAssertEqual(lat,0)
                XCTAssertEqual(long,0)
            }
        } catch {
            print("Failed")
        }
        
        let entry1 = Entry()
        entry1.startTime = Date() //set start time of attack, time zone
        entry1.latitude = nil
        entry1.longitude = nil
        testVC.saveEntry(entry: entry1)
        
        
        // assertions
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: true)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let date = data.value(forKey: "start_time") as! Date
                let lat = data.value(forKey: "latitude") as! Double
                let long = data.value(forKey: "longitude") as! Double
                XCTAssertEqual(date,entry1.startTime)
                XCTAssertNil(lat)
                XCTAssertNil(long)
            }
        } catch {
            print("Failed")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
