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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let durations = getDurations()
        setChart(xValues: durations, yValuesBarChart: numPerDuration(durations: durations))
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
        barChartView.data = data
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
                let endTime = data.value(forKey: "end_time") as! Date
                let duration = Double(endTime.timeIntervalSince(startTime))
                if !(array.contains{ $0 == duration}) {
                    array.append(duration)
                }
            }
            print(array.sorted())
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
                let endTime = data.value(forKey: "end_time") as! Date
                let duration = Double(endTime.timeIntervalSince(startTime))
                let index = durations.index(of: duration)
                array[index!] += 1
            }
            print(array)
            return array
        } catch {
            print("Failed")
        }
        return array
    }

}
