//
//  DurationGraphViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/28/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import Charts
import CoreData

class DurationGraphViewController: UIViewController {

    // MARK: - Storyboard Interface
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var rotateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rotateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        let durations = getDurations()
        setChart(xValues: durations, yValuesBarChart: numPerDuration(durations: durations))
    }
    
    // MARK: - Graph Functions
    func setChart(xValues: [Double], yValuesBarChart: [Double]) {
        barChartView.noDataText = "Please provide data for the chart."
        
        var yVals : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yVals.append(BarChartDataEntry(x: xValues[i], y: yValuesBarChart[i])) // are these x and y right
        }

        let barChartSet = BarChartDataSet(values: yVals, label: "Bar Data")
        barChartSet.colors = [NSUIColor(red:0.96, green:0.80, blue:0.40, alpha:1.0), NSUIColor(red:0.325, green:0.443, blue:0.62, alpha:1.0)]
        
        let data = BarChartData(dataSets: [barChartSet])
        barChartView.data = data
        data.setDrawValues(false)
        
        // formatting
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.xAxis.labelPosition = .bottom
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.granularity = 1.0
        
        barChartView.xAxis.axisMinimum = 0;
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
    }
    
    
    
    // MARK: - CoreData Functions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getDurations() -> [Double] {
        var array = [Double]()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let startTime = data.value(forKey: "start_time") as! Date
                let endTime = data.value(forKey: "end_time") as? Date
                if endTime != nil {
                    let duration = ceil(endTime!.timeIntervalSince(startTime)/60)
                    if !(array.contains{ $0 == Double(duration)}) {
                        array.append(Double(duration))
                    }
                }
            }
            return array.sorted()
        } catch {
            print("Failed")
        }
        return array
    }
    
    func numPerDuration(durations: [Double]) -> [Double] {
        var array: [Double] = Array(repeating: 0, count: durations.count)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let startTime = data.value(forKey: "start_time") as! Date
                let endTime = data.value(forKey: "end_time") as? Date
                if endTime != nil {
                    let duration = ceil(endTime!.timeIntervalSince(startTime)/60)
                    let index = durations.index(of: Double(duration))
                    array[index!] += 1
                }
            }
            return array
        } catch {
            print("Failed")
        }
        return array
    }

}

