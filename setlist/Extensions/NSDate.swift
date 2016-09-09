//
//  NSDate.swift
//  Setlist
//
//  Created by Benoit Deguine on 09/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension NSDate {
    
    func getDateFromNumber(month:String)->String {
        
        let dateFormatter = NSDateFormatter()
        
        let months = dateFormatter.monthSymbols
        return months[Int(month)!-1].capitalizedString
    }
    
}
