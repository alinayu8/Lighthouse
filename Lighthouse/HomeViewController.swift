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

class HomeViewController: UIViewController {
    // MARK: - Location
    let location = Location() // set lats and longs of place

    // MARK: - Buttons
    @IBAction func beginEntry(_ sender: UIButton) {
        let entry = Entry()
        entry.startTime = Date() //set start time of attack, time zone
        
        entry.latitude = Double(location.latitude)
        entry.longitude = Double(location.longitude)
        
        saveEntry(entry: entry)
    }
    
    // MARK: - CoreData functions
    func saveEntry(entry: Entry){
        // Connect to the context for the container stack
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Specifically select the Entry entity to save this object to
        let entity = NSEntityDescription.entity(forEntityName: "Entries", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        // Set values one at a time and save
        newEntity.setValue(entry.startTime, forKey: "start_time")
        newEntity.setValue(entry.endTime, forKey: "end_time")
        newEntity.setValue(entry.latitude, forKey: "latitude")
        newEntity.setValue(entry.longitude, forKey: "longitude")
        newEntity.setValue(entry.notes, forKey: "notes")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    // MARK: - Location
    
        
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

