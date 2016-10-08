//
//  GoogleAnalytics.swift
//  Setlist
//
//  Created by Benoit Deguine on 09/10/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class GoogleAnalytics {

    func sendScreenView(name:String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        var builder = GAIDictionaryBuilder.createScreenView().build() as! [NSObject : AnyObject]
        tracker?.send(builder)

    }
    
}
