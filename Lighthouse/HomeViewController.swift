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
    
    // MARK: - Buttons
    @IBAction func triggerButton(_ sender: UIButton) {
        let entry = Entry()
        entry.startTime = Date() //set start time of attack, time zone
        saveEntry(entry: entry)
        print(entry.startTime)
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
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

