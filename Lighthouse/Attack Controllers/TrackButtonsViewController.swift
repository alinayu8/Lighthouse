//
//  TrackButtonsViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreData
import Pastel
//let qodURL: NSURL = NSURL(string: "https://quotes.rest/qod?category=inspire")!
//let data = NSData(contentsOf: qodURL as URL)!
var colorArray = [UIColor]()
class TrackButtonsViewController: UIViewController {
    
    var betterPressed: Bool? = nil
    var numberPressed: Int = 0
    let timeStart: Date = Date()
  
    // MARK: - Quote outlet
  @IBOutlet weak var quoteLabel: UILabel?
  @IBOutlet weak var pastelView: PastelView!
    // MARK: - Buttons 
    
    @IBAction func stopEntryButton(_ sender: UIButton) {
        updateEntry()
    }
    
    @IBAction func betterButton(_ sender: UIButton) {
        if (betterPressed != true) {
            betterPressed = true
            numberPressed += 1
            self.viewDidAppear(true)
        }
        let datapoint = Datapoint()
        datapoint.time = Date() //set start time of attack, time zone
        datapoint.value = 1
        addDatapoint(datapoint: datapoint)
        //randQuote()
    }
    
    @IBAction func worseButton(_ sender: UIButton) {
        if (betterPressed != false) {
            betterPressed = false
            numberPressed += 1
            self.viewDidAppear(true)
        }
        let datapoint = Datapoint()
        datapoint.time = Date() //set start time of attack, time zone
        datapoint.value = -1
        addDatapoint(datapoint: datapoint)
        //randQuote()
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
        
        // Get the last created entry
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        
        //let datapointRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Datapoints")
        
        do {
            let result = try context.fetch(request)
            let entry = result[0] as! NSManagedObject
            
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
  let quotes = ["It is during our darkest moments that we must focus to see the light. \n -Aristotle",
                "I can't change the direction of the wind, but I can adjust my sails to always reach my destination. \n -Jimmy Dean",
                "I will love the light for it shows me the way, yet I will endure the darkness because it shows me the stars. \n -Og Mandino",
                "Our greatest glory is not in never falling, but in rising every time we fall. \n -Confucius",
                "Promise me you'll always remember: You're braver than you believe, and stronger than you seem, and smarter than you think. \n -Christopher Robin",
                "Keep your face to the sunshine and you cannot see a shadow. \n -Helen Keller",
                "We must accept finite disappointment, but we must never lose infinite hope. \n -Martin Luther King",
                "When everything seems to be going against you, remember that the airplane takes off against the wind, not with it. \n -Henry Ford",
                "It is only in our darkest hours that we may discover the true strength of the brilliant light within ourselves that can never, ever, be dimmed. \n -Doe Zantamata",
                "Courage doesn’t always roar. Sometimes courage is the quiet voice at the end of the day, saying, “I will try again tomorrow. \n -Mary Anne Radmacher"
  ]
  
  //pick a random element from array of quotes
  func randQuote() {
    let random = quotes.randomElement()
    quoteLabel?.text = random
  }
  
  
  func setupBG() {
    let pastelView = PastelView(frame: view.bounds)
    pastelView.animationDuration = 3.0
    var colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)]
    //colors = [#colorLiteral(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),#colorLiteral(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0), #colorLiteral(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),#colorLiteral(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),#colorLiteral(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),#colorLiteral(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),#colorLiteral(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
    
    if (betterPressed == nil) {
        
        
    } else if (betterPressed == true) {
      colors = [#colorLiteral(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),#colorLiteral(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),#colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1),#colorLiteral(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.8901960784, blue: 0.5843137255, alpha: 1)]
    } else if (betterPressed == false) {
        colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 1, green: 0.462745098, blue: 0.462745098, alpha: 1)]
    
      // [#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.9607843137, green: 0.3058823529, blue: 0.6352941176, alpha: 1),#colorLiteral(red: 1, green: 0.462745098, blue: 0.462745098, alpha: 1),]
    }
    
    pastelView.setColors(colors)
    pastelView.startPastelPoint = .bottomLeft
    pastelView.endPastelPoint = .topRight
    pastelView.startAnimation()
    view.insertSubview(pastelView, at: numberPressed)
    
  }
    

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupBG()
  }
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        randQuote()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

