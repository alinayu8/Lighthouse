//
//  ViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 10/29/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

// MARK: Protocol Methods

//protocol HomeViewControllerDelegate: class {
//
//    func saveEntry(controller: HomeViewController, entry: Entry)
//
//}

// MARK: - AddEntriesController

class HomeViewController: UIViewController {
    
    // MARK: - Properties
//    weak var delegate: HomeViewControllerDelegate?
    
    // MARK: - Location
    let location = Location() // set lats and longs of place

    // MARK: - Buttons
    @IBAction func beginEntry(_ sender: UIButton) {
        let entry = Entry()
        entry.startTime = Date() //set start time of attack, time zone
        
        entry.latitude = Double(location.latitude)
        entry.longitude = Double(location.longitude)
        
        entry.saveEntry()
    }
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        location.getCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

