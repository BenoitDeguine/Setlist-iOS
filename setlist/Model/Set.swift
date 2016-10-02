//
//  Set.swift
//  Setlist
//
//  Created by Benoit Deguine on 04/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Set {
    
    var name:String!
    var song = [Song]()
    var isEncore:Bool = false
    
    init(value:NSDictionary) {

        if value.object(forKey: "@name") != nil {
            self.name = value.object(forKey: "@name") as! String
        } else {
            self.name = ""
        }
        
        // Si le set est un "Encore"
        if value.object(forKey: "@encore") != nil {
            self.isEncore = true
            
            if value.object(forKey: "@name") != nil {
                 self.name = value.object(forKey: "@name") as! String
            } else {
                 self.name = value.object(forKey: "@encore") as! String
            }
        } else {
            self.isEncore = false
        }
        
        if ( (value.object(forKey: "song")! as! NSObject) is NSArray ) {
            let songsSet = value.object(forKey: "song") as! NSArray
            
            if (songsSet.count > 0 ) {
                for i in songsSet {
                    self.song.append(Song(value: i as! NSDictionary))
                }
            }
        } else {
            self.song.append(Song(value: value.object(forKey: "song") as! NSDictionary))
        }
    }
    
}
