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
    
    init(value:NSDictionary) {
        
        if value.objectForKey("@name") != nil {
            self.name = value.objectForKey("@name") as! String
        } else {
            self.name = ""
        }
        
        if (value.objectForKey("song")!.isKindOfClass(NSArray)) {
            let songsSet = value.objectForKey("song") as! NSArray
            
            if (songsSet.count > 0 ) {
                for i in songsSet {
                    self.song.append(Song(value: i as! NSDictionary))
                }
            }
        } else {
            
        }
    }
    
}
