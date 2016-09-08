//
//  UITableVie.swift
//  Setlist
//
//  Created by Benoit Deguine on 08/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: {
            self.reloadData() })
        { _ in completion() }
    }
}