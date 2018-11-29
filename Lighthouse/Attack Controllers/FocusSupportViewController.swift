//
//  FocusSupportViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit

class FocusSupportViewController: UIViewController {
    
    @IBOutlet weak var focusSupportSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var supportContainer: UIView!
    @IBOutlet weak var focusContainer: UIView!
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch focusSupportSegmentedControl.selectedSegmentIndex
        {
        case 0:
            focusContainer.isHidden = false
            supportContainer.isHidden = true
        case 1:
            focusContainer.isHidden = true
            supportContainer.isHidden = false
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

