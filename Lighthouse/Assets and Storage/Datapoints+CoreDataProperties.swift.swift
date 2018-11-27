//
//  Datapoints+CoreDataProperties.swift
//  
//
//  Created by Alina Yu on 11/26/18.
//
//

import Foundation
import CoreData


extension Datapoints {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Datapoints> {
        return NSFetchRequest<Datapoints>(entityName: "Datapoints")
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var value: Int16
    @NSManaged public var entry: Entries?

}
