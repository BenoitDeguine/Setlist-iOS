//
//  NSNumber.swift
//  Setlist
//
//  Created by Benoit Deguine on 05/10/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import Foundation

extension NSNumber {
    
    func increment(number:NSNumber)->NSNumber {
        var num: NSNumber = number
        
        num = num.intValue + 1
        
        return num
    }
    
}

