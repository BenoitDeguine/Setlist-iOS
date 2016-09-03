//
//  Artist.swift
//  Setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Artist {
    
    var name:String = ""
    var disambiguation:String = ""
    var mbid:String = ""
    var image:UIImage = UIImage()
    var thumbnails:String = ""
    
    init() {
        
    }
    
    init(name:String, mbid:String, disambiguation:String = "") {
        self.name = name
        self.mbid = mbid
        self.disambiguation = disambiguation
    }
    
    func getImage()->UIImage {
        return UIImage(data: NSData(contentsOfURL: NSURL(string: self.thumbnails)!)!)!
    }
    
}
