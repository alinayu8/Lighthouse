//
//  GraphViewModel.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/28/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation

class GraphModel: NSObject {
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
