//
//  Artists+CoreDataProperties.swift
//  setlist
//
//  Created by Benoit Deguine on 01/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artists {

    @NSManaged var dateAdd: NSDate?
    @NSManaged var mbid: String?
    @NSManaged var name: String?
    
    func getName()->String {
        return self.name!
    }

}
