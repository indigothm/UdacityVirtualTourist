//
//  Photo.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 01/02/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    struct Keys {
        static let URL = "url"
        static let createdAt = "createdAt"
        static let location = "location"
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        url = dictionary[Keys.URL] as! String
        createdAt = dictionary[Keys.createdAt] as! NSDate
        location = dictionary[Keys.location] as? Location
    }
    
    
}
