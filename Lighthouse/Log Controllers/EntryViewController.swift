//
//  EntryViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import CoreLocation
import Charts
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
    }
    
    // MARK: - Entry details
    
//    var entryDetail: Entry? {
//        didSet {
//            // Update the view.
//            self.configureView()
//        }
//    }
//    
//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail: Entry = self.entryDetail {
//            if let location = self.locationLabel {
//                location.text = locationName(latitude: detail.latitude!, longitude: detail.longitude!)
//            }
//            if let dateTime = self.dateTimeLabel {
//                dateTime.text = "bloop"
//            }
//            if let duration = self.dateTimeLabel {
//                duration.text = "bloop"
//            }
//            if let notes = self.notesField {
//                notes.text = "bloop"
//            }
//        }
//    }
    
    // MARK: - Functions
//    func locationName(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
//        var location = CLLocation(latitude: latitude, longitude: longitude)
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//            print(location)
//
//            if error != nil {
//                println("Reverse geocoder failed with error" + error.localizedDescription)
//                return
//            }
//
//            if placemarks.count > 0 {
//                let pm = placemarks[0] as! CLPlacemark
//                println(pm.locality)
//            }
//            else {
//                println("Problem with the data received from geocoder")
//            }
//        })
//    }
    
//    func dateTimeFormat(startTime: Date) -> String {
//        
//    }
//    
//    func durationTime(startTime: Date, endTime: Date) -> String {
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
