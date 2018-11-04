//
//  Entry.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/3/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation
import CoreLocation

class Entry: NSObject {
    var startTime: Date = Date()
    var endTime: Date?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var notes: String?
    
    override init() {
        super.init()
    }
    
    init(startTime: Date, endTime: Date, latitude: CLLocationDegrees, longitude: CLLocationDegrees, notes: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        super.init()
    }
}


