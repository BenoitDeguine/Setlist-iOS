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
    var numberSongs:Int = 0
    
    init(value:NSDictionary) {
        self.id = value.object(forKey: "@id")! as! String
        self.date = value.object(forKey: "@eventDate")! as! String
        self.lastUpdated = value.object(forKey: "@lastUpdated")! as! String
        if value.object(forKey: "@tour") != nil {
            self.tour = value.object(forKey: "@tour")! as! String
        }
        self.versionId = value.object(forKey: "@versionId")! as! String
        self.venue = Venue(value: value.object(forKey: "venue")! as! NSDictionary)
        
        if value.object(forKey: "sets") != nil && ((value.object(forKey: "sets")! as! NSObject) is NSArray) || ((value.object(forKey: "sets")! as! NSObject) is NSDictionary) {
            let sets = value.object(forKey: "sets")! as! NSDictionary
            
            if ((sets.object(forKey: "set")! as! NSObject) is NSArray) {
                let set = sets.object(forKey: "set")! as! NSArray
                
                for i in set {
                    self.sets.append(Set(value:i as! NSDictionary))
                    self.numberSongs += (self.sets.last?.song.count)!
                }

            } else {
                let set = sets.object(forKey: "set")! as! NSDictionary
                self.sets.append(Set(value:set))
                self.numberSongs += (self.sets.last?.song.count)!
            }
        }
        
    }
    
    func getDateMMYYYY()->String {
        return String(self.date.characters.dropFirst(3))
    }
    
    func getDateDD()->String {
        // truncate : on retire les 8 derniers chiffres
        return self.date.substring(to: self.date.index(self.date.endIndex, offsetBy: -8))
    }
    
    func getAnalyticsName()->String {
       return String(self.date + " | " + self.id )
    }
    
}
