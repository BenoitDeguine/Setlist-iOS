//
//  Artist.swift
//  Setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Artist {
    
    var name:String!
    var disambiguation:String!
    var mbid:String!
    var thumbnails:String!
    var yearDebut:String!
    
    init() {
        
    }
    
    init(name:String, mbid:String, disambiguation:String = "", debut:String = "") {
        self.name = name
        self.mbid = mbid
        self.disambiguation = disambiguation
        self.yearDebut = debut
    }
    
    init(value:NSDictionary){
        if ((value).object(forKey: "disambiguation") != nil) {
            self.disambiguation = (value).object(forKey: "disambiguation") as! String
        }
        
        if ((value).object(forKey: "name") != nil) {
            self.name = (value).object(forKey: "name") as! String
        }
        
        if ((value).object(forKey: "id") != nil) {
            self.mbid = (value).object(forKey: "id") as! String
        }
    }
    
    func getImage()->UIImage {
        return UIImage(data: try! Data(contentsOf: URL(string: self.thumbnails)!))!
    }
    
}
