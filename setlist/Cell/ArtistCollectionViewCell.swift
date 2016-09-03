//
//  ArtistCellCollectionViewCell
//  Setlist
//
//  Created by Benoit Deguine on 01/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class ArtistCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var name:UILabel!
    
    var artist:Artist!
    
    func configureCell(artist:Artist){
        self.artist = artist
    }
    
}
