//
//  Venue.swift
//  Setlist
//
//  Created by Benoit Deguine on 04/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class Venue {
    
    struct Coordinates {
        var Latitude: String
        var Longitude: String
    }
    
    var id:String!
    var name:String!
    var cityName:String!
    var cityState:String!
    var cityStateCode:String!
    var cityCountryName:String!
    var cityCoords:Coordinates
    
    init(value:NSDictionary){
        self.id = value.objectForKey("@id")! as! String
        self.name = value.objectForKey("@name")! as! String
        
        // City
        let city:NSDictionary = value.objectForKey("city")! as! NSDictionary
        self.cityName = city.objectForKey("@name") as! String
        if city.objectForKey("@state") != nil {
            self.cityState = city.objectForKey("@state") as! String
        } else {
            self.cityState = ""
        }
        if city.objectForKey("@state") != nil {
            self.cityStateCode = city.objectForKey("@stateCode") as! String
        } else {
            self.cityStateCode = ""
        }
        
        // Country
        let country:NSDictionary = city.objectForKey("country")! as! NSDictionary
        self.cityCountryName = country.objectForKey("@name")! as! String
        
        // Coords
        let coords:NSDictionary = city.objectForKey("coords")! as! NSDictionary
        self.cityCoords = Coordinates(Latitude: coords.objectForKey("@lat")! as! String, Longitude: coords.objectForKey("@long")! as! String)
        
    }
    
    func getVenueName()->String {
        var venue:String = String()
        
        if (self.name != "") {
            venue = self.name
        } else {
            venue = NSLocalizedString("venue_unknown", comment: "")
        }
        
        return venue
    }
    
    func getVenueAddress()->String {
        
        var venue:String = String()
        
        if (self.cityName != "") {
            venue = venue + self.cityName
        }
        
        if (venue != "") {
            venue = venue + ", "
        }
        
        if (self.cityState != "") {
            venue = venue + self.cityState
        }
        
        return venue
    }
}
