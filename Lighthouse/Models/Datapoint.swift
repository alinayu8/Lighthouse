//
//  Datapoint.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/3/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation

class Datapoint: NSObject {
    var value: Int?
    var time: Date?
    
    override init() {
        super.init()
    }
    
    init(value: Int, time: Date) {
        self.value = value
        self.time = time
        super.init()
    }
}


