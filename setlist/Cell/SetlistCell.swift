//
//  SetlistCellTape.swift
//  Setlist
//
//  Created by Benoit Deguine on 12/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class SetlistCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.textColor = UIColor().buttonColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
