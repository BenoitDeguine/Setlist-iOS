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

        if value.objectForKey("@name") != nil {
            self.name = value.objectForKey("@name") as! String
        } else {
            self.name = ""
        }
        
        // Si le set est un "Encore"
        if value.objectForKey("@encore") != nil {
            self.isEncore = true
            self.name = value.objectForKey("@encore") as! String
        } else {
            self.isEncore = false
        }
        
        if (value.objectForKey("song")!.isKindOfClass(NSArray)) {
            let songsSet = value.objectForKey("song") as! NSArray
            
            if (songsSet.count > 0 ) {
                for i in songsSet {
                    self.song.append(Song(value: i as! NSDictionary))
                }
            }
        } else {
            self.song.append(Song(value: value.objectForKey("song") as! NSDictionary))
        }
    }
    
}
