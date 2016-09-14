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
        self.id = value.object(forKey: "@id")! as! String
        self.name = value.object(forKey: "@name")! as! String
        
        // City
        let city:NSDictionary = value.object(forKey: "city")! as! NSDictionary
        
        if (city.object(forKey: "@name") != nil) {
            
            print(city)
            
            // En version FR, setlist FM traduit Paris par Paname
            if ((city.object(forKey: "@name") as! String).lowercased() == "paname") {
                self.cityName = "Paris"
            } else {
                self.cityName = city.object(forKey: "@name") as! String
            }
        }
        
        if city.object(forKey: "@state") != nil {
            self.cityState = city.object(forKey: "@state") as! String
        } else {
            self.cityState = ""
        }
        if city.object(forKey: "@state") != nil {
            self.cityStateCode = city.object(forKey: "@stateCode") as! String
        } else {
            self.cityStateCode = ""
        }
        
        // Country
        let country:NSDictionary = city.object(forKey: "country")! as! NSDictionary
        self.cityCountryName = country.object(forKey: "@name")! as! String
        
        // Coords
        let coords:NSDictionary = city.object(forKey: "coords")! as! NSDictionary
        self.cityCoords = Coordinates(Latitude: coords.object(forKey: "@lat")! as! String, Longitude: coords.object(forKey: "@long")! as! String)
        
    }
    
    func getVenueName()->String {
        var venue:String = String()
        
        if (self.name != "") {
            venue = self.name.capitalized
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
        
        if (self.cityState != "") {
            if (venue != "") {
                venue = venue + ", "
            }
            venue = venue + self.cityState
        }
        
        if (self.cityCountryName != "") {
            if (venue != "") {
                venue = venue + ", "
            }
            venue = venue + self.cityCountryName
        }
        
        return venue
    }
}
