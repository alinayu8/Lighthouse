//
//  TrackButtonsViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/2/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit

// MARK: Protocol Methods

protocol TrackButtonsViewControllerDelegate: class {
    func saveEntry(controller: TrackButtonsViewController, entry: Entry)
    func lastEntry(controller: TrackButtonsViewController) -> Entry?
}

class TrackButtonsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TrackButtonsViewControllerDelegate?
    
    // MARK: - Buttons
    
    @IBAction func stopEntryButton(_ sender: UIButton) {
        let entry = delegate?.lastEntry(controller: self)
        entry?.endTime = Date()
        delegate?.saveEntry(controller: self, entry: entry!)
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

