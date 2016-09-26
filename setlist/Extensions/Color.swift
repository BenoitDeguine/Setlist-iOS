//
//  Color.swift
//  setlist
//
//  Created by Benoit Deguine on 23/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension UIColor{
    
    func mainColor()->UIColor {
        return self.hexStringToUIColor("#85b146")
    }

    func backgroundColor()->UIColor {
        return self.hexStringToUIColor("#F5F5F5")
    }
    
    func buttonColor()->UIColor {
        return self.hexStringToUIColor("#FFFFFF")
    }
    
    func tapeSetlistColor()->UIColor {
        return self.hexStringToUIColor("#999999")
    }
    
    func darkGrey()->UIColor {
        return self.hexStringToUIColor("#7f8c8d")
    }
    
    func hexStringToUIColor(_ hex:String)->UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

