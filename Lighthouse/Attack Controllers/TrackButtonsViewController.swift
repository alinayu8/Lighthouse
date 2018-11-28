//
//  TrackButtonsViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData
let qodURL: NSURL = NSURL(string: "https://quotes.rest/qod?category=inspire")!
let data = NSData(contentsOf: qodURL as URL)!
class TrackButtonsViewController: UIViewController {
  
    // MARK: - Quote
  @IBOutlet weak var quoteLabel: UILabel?
  @IBOutlet weak var authorLabel: UILabel?
    // MARK: - Buttons 
    
    @IBAction func stopEntryButton(_ sender: UIButton) {
        updateEntry()
    }
    
    @IBAction func betterButton(_ sender: UIButton) {
        let datapoint = Datapoint()
        datapoint.time = Date() //set start time of attack, time zone
        datapoint.value = 1
        addDatapoint(datapoint: datapoint)
    }
    
    @IBAction func worseButton(_ sender: UIButton) {
        let datapoint = Datapoint()
        datapoint.time = Date() //set start time of attack, time zone
        datapoint.value = -1
        addDatapoint(datapoint: datapoint)
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
    
    func addDatapoint(datapoint: Datapoint) {
        let context = appDelegate.persistentContainer.viewContext
        
        // Save datapoints to entry
        let datapointEntity = NSEntityDescription.entity(forEntityName: "Datapoints", in: context)
        let newDatapointEntity = NSManagedObject(entity: datapointEntity!, insertInto: context)
        newDatapointEntity.setValue(datapoint.time, forKey: "time")
        newDatapointEntity.setValue(datapoint.value, forKey: "value")
        print("\(datapoint.value) at \(datapoint.time)")
        
        // Get the last created entry
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        
        //let datapointRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Datapoints")
        
        do {
            let result = try context.fetch(request)
            let entry = result[0] as! NSManagedObject
            
            let currentDatapoints = entry.value(forKey: "datapoints") as? NSSet

            if let currentDatapoints = entry.value(forKey: "datapoints") as? NSSet {
                let newDatapoints = currentDatapoints.adding(newDatapointEntity)
                entry.setValue(newDatapoints, forKey: "datapoints") // set datapoint to this entry
            }
            
            do {
                try context.save()
            } catch {
                print("Failed")
            }
        } catch {
            print("Failed")
        }
    }
  
  
  func pullQuote() {
    
    var results = [String]()
    
    do {
      let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:AnyObject]
      if let contents = json["contents"] as? NSDictionary {
        
        print(contents)
        if let quoteDatas = contents["quotes"] as? [NSDictionary] {
          for quoteData in quoteDatas{
            print(quoteData)
            for kvpair in quoteData {
              if let left = kvpair.0 as? String {
                if left == "quote" {
                  if let right = kvpair.1 as? String {
                    results.append (right)
                  }
                }
                if left == "author" {
                  if let right = kvpair.1 as? String {
                    results.append (right)
                  }
                }
              }
            }
          }
        }
      }
      
    }catch {
      print("error serializing JSON: \(error)")
    }
    let size = results.count
    if size == 2 {
      authorLabel?.text = results[0]
      quoteLabel?.text = results[1]
    }
  }
  
  
  
    
    //newPerson.setValue(NSSet(object: newAddress), forKey: "addresses")

    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pullQuote()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

