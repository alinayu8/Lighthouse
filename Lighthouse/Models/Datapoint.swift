//
//  Datapoint.swift
//  Lighthouse
//
//  Created by Shirley Zhou on 11/9/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation

class Datapoint: NSObject {
  
  var better_tap: Int?
  var worse_tap: Int?
  var time: Date?
  
  override init() {
    super.init()
  }
  
  init(better_tap: Int, worse_tap: Int, time: Date?) {
    self.better_tap = better_tap
    self.worse_tap = worse_tap
    self.time = time
  }
  
}
