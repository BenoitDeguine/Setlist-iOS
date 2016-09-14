//
//  NSDate.swift
//  Setlist
//
//  Created by Benoit Deguine on 09/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension Date {
    
    func getDateFromNumber(_ month:String)->String {
        
        let dateFormatter = DateFormatter()
        
        let months = dateFormatter.monthSymbols
        return months![Int(month)!-1].capitalized
    }
    
}
