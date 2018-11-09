//
//  LogViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    //MARK: - Segmented Control
    
    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var statsContainer: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            listContainer.isHidden = false
            statsContainer.isHidden = true
        case 1:
            listContainer.isHidden = true
            statsContainer.isHidden = false
        default:
            break
        }
    }
    
    //MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
