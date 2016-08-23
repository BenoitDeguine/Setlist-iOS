//
//  Artists+CoreDataProperties.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artists {

    @NSManaged var name: String?
    @NSManaged var mbid: String?
    @NSManaged var image: String?
    @NSManaged var dateAdd: NSDate?

}
