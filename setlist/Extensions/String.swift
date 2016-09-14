//
//  String.swift
//  Setlist
//
//  Created by Benoit Deguine on 10/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}
