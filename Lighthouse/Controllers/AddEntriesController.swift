//
//  AddEntriesController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/3/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddEntriesController: UIViewController, HomeViewControllerDelegate, TrackButtonsViewControllerDelegate {
    
    // MARK: - General
    
    var entries: [Entry] = []

    // MARK: - CoreData functions for HomeView
    
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveEntry(entry: Entry) {
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
    
    func lastEntry() -> Entry? {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let newEntry = Entry() // can this be faster
                newEntry.startTime = (data.value(forKey: "start_time") as! Date)
                newEntry.endTime = (data.value(forKey: "end_time") as! Date)
                newEntry.latitude = (data.value(forKey: "latitude") as! Double)
                newEntry.longitude = (data.value(forKey: "longitude") as! Double)
                newEntry.notes = (data.value(forKey: "notes") as! String)
                entries.append(newEntry)
            }
            return entries.last
        } catch {
            print("Failed")
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeVC" {
            let homeVC: HomeViewController = segue.destination as! HomeViewController
            homeVC.delegate = self as HomeViewControllerDelegate
            print("\n-- I'm \(String(describing: homeVC))'s delegate: \(String(describing: homeVC.delegate))\n")
        } else if segue.identifier == "trackVC" {
            let trackVC: TrackButtonsViewController = segue.destination as! TrackButtonsViewController
            trackVC.delegate = self as TrackButtonsViewControllerDelegate
            print("\n-- I'm \(String(describing: trackVC))'s delegate: \(String(describing: trackVC.delegate))\n")
        }
    }
    
}
