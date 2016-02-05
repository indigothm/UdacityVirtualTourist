//
//  Location+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 01/02/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var createdAt: NSDate
    @NSManaged var photos: [Photo]
    


}
