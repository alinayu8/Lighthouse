//
//  StartTimeGraphViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/28/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import Charts
import CoreData

class StartTimeGraphViewController: UIViewController {

    // MARK: - Storyboard Interface
    
    let startTimes = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0]
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var rotateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rotateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        setChart(xValues: startTimes, yValuesBarChart: numPerStartTime(startTimes: startTimes))
    }
    
    // MARK: - Graph Functions
    func setChart(xValues: [Double], yValuesBarChart: [Double]) {
        barChartView.noDataText = "Please provide data for the chart."
        
        var yVals : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yVals.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i])) // are these x and y right
        }
        
        let barChartSet = BarChartDataSet(values: yVals, label: "Bar Data")
        let data = BarChartData(dataSets: [barChartSet])
        data.setDrawValues(false)
        barChartView.data = data
        //color
        barChartSet.colors = [NSUIColor(red:0.96, green:0.80, blue:0.40, alpha:1.0)]
      
        // formatting
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.xAxis.labelPosition = .bottom
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.granularity = 1.0
    }
    
    // MARK: - CoreData Functions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func numPerStartTime(startTimes: [Double]) -> [Double] {
        var array: [Double] = Array(repeating: 0, count: startTimes.count)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let startTime = data.value(forKey: "start_time") as! Date
                let time = dateFormat(startTime: startTime)
                let index = startTimes.index(of: Double(time))
                array[index!] += 1
            }
            print(array)
            return array
        } catch {
            print("Failed")
        }
        return array
    }
    
    func dateFormat(startTime: Date) -> Int {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: startTime))!
    }

}
