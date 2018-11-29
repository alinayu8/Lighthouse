//
//  MonthGraphViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/28/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import Charts
import CoreData

class MonthGraphViewController: UIViewController {
    
    // MARK: - Storyboard Interface
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(xValues: months, yValuesLineChart: avgPerMonth(), yValuesBarChart: totalPerMonth())
    }
    
    // MARK: - Graph Functions
    
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        combinedChartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()

        for i in 0..<xValues.count {

            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i])) // are these x and y right
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i]))

        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line Data")
        let barChartSet = BarChartDataSet(values: yVals2, label: "Bar Data")
        
        
        let data = CombinedChartData()
        data.barData = BarChartData(dataSets: [barChartSet])
        //data.lineData = LineChartData(dataSets: [lineChartSet])
        
        combinedChartView.data = data
        
    }
    
    // MARK: - CoreData Functions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func totalPerMonth() -> [Double] {
        var array: [Double] = Array(repeating: 0, count: months.count)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let date = data.value(forKey: "start_time") as! Date
                let toDate = Date()
                let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: toDate)
                if (date >= fromDate!) {
                    let month = monthFormat(time: date)
                    let index = months.index(of: month)
                    array[index!] += 1
                }
            }
            print(array)
            return array
        } catch {
            print("Failed")
        }
        return array
    }
    
    func avgPerMonth() -> [Double] {
        var array: [Double] = Array(repeating: 0, count: months.count)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.sortDescriptors = [NSSortDescriptor(key: "start_time", ascending: true)]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var total = 0
            for i in 0..<array.count {
            //for data in result as! [NSManagedObject] {
                let data = result[i] as! NSManagedObject
                let date = data.value(forKey: "start_time") as! Date
                let toDate = Date()
                let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: toDate)
                if (date >= fromDate!) {
                    total += 1
                    let month = monthFormat(time: date)
                    let index = months.index(of: month)
                    array[index!] += 1
                }
            }
            print(array)
            return array
        } catch {
            print("Failed")
        }
        return array
    }
    
    func monthFormat(time: Date) -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: time)
    }


}
