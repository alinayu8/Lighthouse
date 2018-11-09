//
//  EntryGraphViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import Charts

class EntryGraphViewController: UIViewController {
  
  @IBOutlet weak var lineChart: LineChartView!
  
  @IBAction func renderCharts() {
    lineChartUpdate()
  }
    
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
