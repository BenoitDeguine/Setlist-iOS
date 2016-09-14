//
//  Artists+CoreDataProperties.swift
//  Setlist
//
//  Created by Benoit Deguine on 14/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import Foundation
import CoreData


extension Artists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artists> {
        return NSFetchRequest<Artists>(entityName: "Artists");
    }

    @NSManaged public var dateAdd: NSDate?
    @NSManaged public var mbid: String?
    @NSManaged public var name: String?

    func getName()->String {
        return self.name!
    }
    
}
