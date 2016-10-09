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
        
        let builder = GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject]
        tracker?.send(builder)

    }
    
    func trackAction(category:String, action:String, label:String = "") {
        let tracker = GAI.sharedInstance().defaultTracker
        let event = GAIDictionaryBuilder.createEvent(
            withCategory: category,
            action: action,
            label: label,
            value: nil).build()  as [NSObject : AnyObject]
        tracker?.send(event)
    }
    
}
