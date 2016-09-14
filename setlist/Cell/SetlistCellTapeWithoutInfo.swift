//
//  SetlistCellTape.swift
//  Setlist
//
//  Created by Benoit Deguine on 12/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class SetlistCellTapeWithoutInfo: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageTape: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageTape.tintColor = UIColor().tapeSetlistColor()
        self.title.textColor = UIColor().tapeSetlistColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
