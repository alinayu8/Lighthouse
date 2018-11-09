//
//  EntryViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreLocation
<<<<<<< HEAD
import CoreData

=======
import Charts
>>>>>>> 9f7de4c22e749a4d6ba34b784850038d1cdf5748
class EntryViewController: UIViewController {
    
    // MARK: - Buttons and Labels
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var lineChart: LineChartView!
  
    //@IBAction func renderCharts() {
//      lineChartUpdate()
//    }
    @IBAction func saveEntryButton(_ sender: Any) {
        updateEntry(notes: notesField.text)
    }
    
    // MARK: - Configure Entry details
    
    var entryDetail: Entry? {
        didSet {
            // Update the view.
            print("hallo1")
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        print("hallo2")
        if let detail: Entry = self.entryDetail {
            if let location = self.locationLabel {
                let currentLocation = CLLocation(latitude: detail.latitude!, longitude: detail.longitude!)
                // convert lat and long to readable address
                CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
                    
                    if placemarks!.count > 0 {
                        let pm = placemarks![0]
                        let address = pm.subThoroughfare!
                        let street = pm.thoroughfare!
                        let city = pm.locality!
                        let postalCode = pm.postalCode!
                        //let locationString3 = pm.country! // USA users?
                        print("no?")
                        location.text = ("\(address) \(street), \(city) \(postalCode)")
                    }
                    else {
                        print("Problem with the data received from geocoder")
                    }
                })
            }
            if let dateTime = self.dateTimeLabel {
                dateTime.text = dateTimeFormat(startTime: detail.startTime!)
            }
            if let duration = self.durationLabel {
                duration.text = durationTime(startTime: detail.startTime!, endTime: detail.endTime!)
            }
            if let notes = self.notesField {
                notes.text = detail.notes ?? ""
            }
        }
    }
    
    // MARK: - Functions
 
    func dateTimeFormat(startTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
        return dateFormatter.string(from: startTime)
    }

    func durationTime(startTime: Date, endTime: Date) -> String {
        let duration = endTime.timeIntervalSince(startTime)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute, .second]
        
        // Use the configured formatter to generate the string.
        let timeString = formatter.string(from: duration) ?? ""
        return timeString
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateEntry(notes: String) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let detail: Entry = self.entryDetail {
                    if (detail.startTime == (data.value(forKey: "start_time") as! Date) &&
                        detail.endTime == (data.value(forKey: "end_time") as! Date) &&
                        detail.latitude == (data.value(forKey: "latitude") as! Double) &&
                        detail.longitude == (data.value(forKey: "longitude") as? Double) &&
                        detail.notes == (data.value(forKey: "notes") as? String)) {
                        print(notes)
                        data.setValue(notes, forKey: "notes")
                        try context.save()
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // Style text view
        let myColor = UIColor.gray
        notesField.layer.borderColor = myColor.cgColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 10.0
        lineChartUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func lineChartUpdate() {
      
      // Basic set up of chart
      
      let entry1 = ChartDataEntry(x: 1.0, y: Double(3))
      let entry2 = ChartDataEntry(x: 2.0, y: Double(5))
      let entry3 = ChartDataEntry(x: 3.0, y: Double(2))
      let dataSet = LineChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
      let data = LineChartData(dataSets: [dataSet])
      lineChart.data = data
      lineChart.chartDescription?.text = "Number of Widgets by Type"
      
      // Color
      dataSet.colors = ChartColorTemplates.vordiplom()
      
      // Refresh chart with new data
      lineChart.notifyDataSetChanged()
    }
    
}
