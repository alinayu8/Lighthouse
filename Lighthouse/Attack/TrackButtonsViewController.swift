//
//  TrackButtonsViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData

class TrackButtonsViewController: UIViewController {
    // MARK: - Buttons
    
    @IBAction func stopEntryButton(_ sender: UIButton) {
        updateEntry()
    }
    
    // MARK: - CoreData functions
    
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateEntry() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let objectUpdate = result[0] as! NSManagedObject
            objectUpdate.setValue(Date(), forKey: "end_time")
            do {
                try context.save()
            } catch {
                print("Failed")
            }
        } catch {
            print("Failed")
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

