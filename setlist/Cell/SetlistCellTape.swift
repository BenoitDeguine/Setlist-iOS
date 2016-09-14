//
//  SetlistCellTape.swift
//  Setlist
//
//  Created by Benoit Deguine on 12/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class SetlistCellTape: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var imageTape: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageTape.tintColor = UIColor().tapeSetlistColor()
        self.title.textColor = UIColor().tapeSetlistColor()
        self.info.textColor = UIColor().tapeSetlistColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
