//
//  EntryViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Charts

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Buttons and Labels
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var lineChart: LineChartView!
  
//    @IBAction func renderCharts() {
//      lineChartUpdate()
//    }
   
    // MARK: - Configure Entry details
    
    var entryDetail: Entry? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Entry = self.entryDetail {
            if let location = self.locationLabel {
                if (detail.latitude != 0) && (detail.longitude != 0) { // make sure location exists
                    let currentLocation = CLLocation(latitude: detail.latitude!, longitude: detail.longitude!)
                    // convert lat and long to readable address
                    CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
                        
                        if let places = placemarks {
                            if places.count > 0 {
                                let pm = places[0]
                                let address = pm.subThoroughfare!
                                let street = pm.thoroughfare!
                                let city = pm.locality!
                                let postalCode = pm.postalCode!
                                //let locationString3 = pm.country! // USA users?
                                location.text = ("\(address) \(street), \(city) \(postalCode)")
                                
//                                let attributedString = NSMutableAttributedString(string: "Just click here to register")
//                                let url = URL(string: "https://www.apple.com")!
//
//                                // Set the 'click here' substring to be the link
//                                attributedString.setAttributes([.link: url], range: NSMakeRange(5, 10))
//
//                                self.textView.attributedText = attributedString
//                                self.textView.isUserInteractionEnabled = true
//                                self.textView.isEditable = false
//
//                                // Set how links should appear: blue and underlined
//                                self.textView.linkTextAttributes = [
//                                    .foregroundColor: UIColor.blue,
//                                    .underlineStyle: NSUnderlineStyle.single.rawValue
//                                ]
                                
                            }
                            else {
                                print("Problem with the data received from geocoder")
                            }
                        } else {
                            location.text = ("\(detail.latitude!), \(String(describing: detail.longitude))")
                        }
                    })
                } else {
                    location.text = "Location could not be recorded."
                }
            }
            if let date = self.dateLabel {
                date.text = dateFormat(startTime: detail.startTime!)
            }
            if let time = self.timeLabel {
                time.text = timeFormat(startTime: detail.startTime!)
            }
            if let duration = self.durationLabel {
                duration.text = durationTime(startTime: detail.startTime!, endTime: detail.endTime!)
            }
            if let notes = self.notesField {
                notes.text = detail.notes ?? ""
            }
        }
    }
    
    // MARK: - General Functions
 
    func dateFormat(startTime: Date) -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: startTime)
    }

    func timeFormat(startTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
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
//        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: false)]
//        request.fetchLimit = 1
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
                        data.setValue(notes, forKey: "notes")
                        try context.save()
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    // MARK: - Chart functions
    
    // Order datapoints by time because sets suck
    func sortDatapoints(timeArray: Array<Double>, dpArray: Array<ChartDataEntry>) -> Array<ChartDataEntry> {
        var sortedDPArray: [Any] = Array(repeating: "", count: dpArray.count)
        let sortedTimeArray = timeArray.sorted(by: <)
        for dp in dpArray {
            let time = dp.x
            let index = sortedTimeArray.index(of: time)
            sortedDPArray[index!] = dp
        }
        return sortedDPArray as! Array<ChartDataEntry>
    }
    
    // Sums up the array of values passed by listDatapoints
    func sumDatapoints(array: Array<ChartDataEntry>) -> Array<ChartDataEntry> {
        var datapointArray: [ChartDataEntry] = [];
        var previousTime = 0.0
        var total = 0.0
        
        for datapoint in array {
            let currentTime = datapoint.x
            let currentValue = datapoint.y
            
            // If entering new time datapoint
            if (previousTime != currentTime) {
                let x = previousTime
                datapointArray.append(ChartDataEntry(x: x, y: total))
            }
            previousTime = datapoint.x
            total += currentValue
        }
        
        datapointArray.append(ChartDataEntry(x: previousTime, y: total))
        
        return datapointArray
    }
    
    // Returns array of summed datapoints from CoreData (time, value)
    func listDatapoints() -> Array<ChartDataEntry> {
        var datapointArray: [ChartDataEntry] = []
        var timesArray: [Double] = []
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
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
                    
                        let datapoints = data.value(forKeyPath: "datapoints") as? Set<NSManagedObject>
                        
                        for point in datapoints! {
                            let dpTime = point.value(forKey: "time") as? Date
                            // force unwrapping a lot of things
                            let time = Double(dpTime!.timeIntervalSince(detail.startTime!)) // converting to seconds since entry began
                            let value = Double((point.value(forKey: "value") as? Int)!)
                            datapointArray.append(ChartDataEntry(x: time, y: value))
                            timesArray.append(time)
                        }
                    }
                }
            }
        } catch {
            print("Failed")
        }
        let sortedArray = sortDatapoints(timeArray: timesArray, dpArray: datapointArray)
        let summedDatapointArray = sumDatapoints(array: sortedArray)
        return summedDatapointArray
    }
    
    func lineChartUpdate() {
        let dataArray = listDatapoints()
        let dataSet = LineChartDataSet(values: dataArray, label: "sum of button presses at given time")
        let data = LineChartData(dataSets: [dataSet])
        lineChart.data = data
        //lineChart.chartDescription?.text = "Number of Widgets by Type"
        
        // Color
        //dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Refresh chart with new data
        lineChart.notifyDataSetChanged()
    }
    
    // MARK: - Notes and Keyboard Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        updateEntry(notes: notesField.text)
    }
    
    // MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.notesField.delegate = self as? UITextViewDelegate
        
        // Style text view
        let myColor = UIColor.gray
        notesField.layer.borderColor = myColor.cgColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 10.0
        lineChartUpdate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EntryViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EntryViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tap in view to exit keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
