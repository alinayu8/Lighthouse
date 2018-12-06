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
import AVFoundation

class HomeViewController: UIViewController {
    
    // MARK: - Location
    let location = Location() // set lats and longs of place

    // MARK: - Buttons
    @IBAction func beginEntry(_ sender: Any) {
        let entry = Entry()
        entry.startTime = Date() //set start time of attack, time zone
        entry.latitude = Double(location.latitude)
        entry.longitude = Double(location.longitude)
        saveEntry(entry: entry)
    }
    
    @IBAction func soundButton(_ sender: Any) {
        if (SoundManager.playing) {
            SoundManager.audioPlayer.pause()
            SoundManager.playing = false
            SoundManager.muted = true
        } else {
            SoundManager.audioPlayer.play()
            SoundManager.playing = true
            SoundManager.muted = false
        }
    }
    
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
        newEntity.setValue(nil, forKey: "end_time")
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
        location.getCurrentLocation()
        if (SoundManager.playing == false && SoundManager.muted == false) {
            SoundManager.playMusic()
            SoundManager.playing = true
            SoundManager.muted = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

