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
    var number:Int = 0
    
    init(value:NSDictionary) {
        print(value)
        
        if value.object(forKey: "@name") != nil {
            self.name = value.object(forKey: "@name") as! String
        } else {
            self.name = ""
        }
        
        if value.object(forKey: "info") != nil {
            self.info = value.object(forKey: "info") as! String
        }
        
        if value.object(forKey: "cover") != nil {
            self.isCover = true
            let cover = value.object(forKey: "cover") as! NSDictionary
            
            if (cover.object(forKey: "@name") != nil) {
                self.artistName = cover.object(forKey: "@name")  as! String
            }
        } else {
            self.isCover = false
        }
        
        if value.object(forKey: "@tape") != nil {
            self.isTape = true
            if (value.object(forKey: "cover") != nil) {
                
                let cover = value.object(forKey: "cover") as! NSDictionary
                
                if (cover.object(forKey: "@name") != nil) {
                    self.artistName = cover.object(forKey: "@name")  as! String
                }
            }
        } else {
            self.isTape = false
        }
        
    }
}
