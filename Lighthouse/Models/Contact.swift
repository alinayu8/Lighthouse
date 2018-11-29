//
//  Contact.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/3/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation
import CoreLocation

class Contact: NSObject {
    var name: String?
    var number: String?
    
    override init() {
        super.init()
    }
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
        super.init()
    }
}


