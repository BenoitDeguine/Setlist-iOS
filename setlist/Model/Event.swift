//
//  Event.swift
//  Setlist
//
//  Created by Benoit Deguine on 04/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Event {
    
    var id:String!
    var tour:String!
    var date:String!
    var lastUpdated:String!
    var versionId:String!
    var venue:Venue!
    var sets = [Set]()
    
    init(value:NSDictionary) {
        
        self.id = value.objectForKey("@id")! as! String
        self.date = value.objectForKey("@eventDate")! as! String
        self.lastUpdated = value.objectForKey("@lastUpdated")! as! String
        if value.objectForKey("@tour") != nil {
            self.tour = value.objectForKey("@tour")! as! String
        }
        self.versionId = value.objectForKey("@versionId")! as! String
        self.venue = Venue(value: value.objectForKey("venue")! as! NSDictionary)
        
        if value.objectForKey("sets") != nil && (value.objectForKey("sets")!.isKindOfClass(NSArray) || (value.objectForKey("sets")!.isKindOfClass(NSDictionary))) {
            let sets = value.objectForKey("sets")! as! NSDictionary
            
            if (sets.objectForKey("set")!.isKindOfClass(NSArray)) {
                let set = sets.objectForKey("set")! as! NSArray
                print("23")
            } else {
                
                print(sets)
                let set = sets.objectForKey("set")! as! NSDictionary
                self.sets.append(Set(value:set))
                
                print("22")
            }
        }
    }
    
    func getDateMMYYYY()->String {
        return String(self.date.characters.dropFirst().dropFirst().dropFirst())
    }
    
}
