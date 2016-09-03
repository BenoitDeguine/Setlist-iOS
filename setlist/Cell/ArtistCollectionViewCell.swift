//
//  ArtistCollectionViewCell.swift
//  Setlist
//
//  Created by Benoit Deguine on 01/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var name:UILabel!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(artist:Artist){
        
        print(artist)
        print(artist.name)
        
        self.name.text = artist.name
        self.name.textColor = UIColor().mainColor()
        self.thumbnail.image = UIImage().getImageFromName(artist.mbid)
    }
    
}
