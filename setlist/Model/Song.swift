//
//  Song.swift
//  Setlist
//
//  Created by Benoit Deguine on 04/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Song {
    
    var name:String!
    var info:String!
    var isCover:Bool!
    var isTape:Bool!
    var artistName:String!
    
    init(value:NSDictionary) {
        print(value)
        
        if value.objectForKey("@name") != nil {
            self.name = value.objectForKey("@name") as! String
        } else {
            self.name = ""
        }
        
        if value.objectForKey("info") != nil {
            self.info = value.objectForKey("info") as! String
        }
        
        if value.objectForKey("cover") != nil {
            self.isCover = true
            let cover = value.objectForKey("cover") as! NSDictionary
            
            if (cover.objectForKey("@name") != nil) {
                self.artistName = cover.objectForKey("@name")  as! String
            }
        } else {
            self.isCover = false
        }
        
        if value.objectForKey("@tape") != nil {
            self.isTape = true
            if (value.objectForKey("cover") != nil) {
                
                let cover = value.objectForKey("cover") as! NSDictionary
                
                if (cover.objectForKey("@name") != nil) {
                    self.artistName = cover.objectForKey("@name")  as! String
                }
            }
        } else {
            self.isTape = false
        }
        
    }
}
