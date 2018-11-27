//
//  Entries+CoreDataProperties.swift
//  
//
//  Created by Alina Yu on 11/26/18.
//
//

import Foundation
import CoreData


extension Entries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entries> {
        return NSFetchRequest<Entries>(entityName: "Entries")
    }

    @NSManaged public var end_time: NSDate?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var notes: String?
    @NSManaged public var start_time: NSDate?
    @NSManaged public var datapoints: NSSet?

}

// MARK: Generated accessors for datapoints
extension Entries {

    @objc(addDatapointsObject:)
    @NSManaged public func addToDatapoints(_ value: Datapoints)

    @objc(removeDatapointsObject:)
    @NSManaged public func removeFromDatapoints(_ value: Datapoints)

    @objc(addDatapoints:)
    @NSManaged public func addToDatapoints(_ values: NSSet)

    @objc(removeDatapoints:)
    @NSManaged public func removeFromDatapoints(_ values: NSSet)

}
