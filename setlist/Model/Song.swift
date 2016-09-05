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
    
    init(value:NSDictionary) {
        
        if value.objectForKey("@name") != nil {
            self.name = value.objectForKey("@name") as! String
        } else {
            self.name = ""
        }
        
        if value.objectForKey("info") != nil {
            self.info = value.objectForKey("info") as! String
        } else {
            self.info = ""
        }
        
        if value.objectForKey("@cover") != nil {
            self.isCover = true
        } else {
            self.isCover = false
        }
        
    }
}
