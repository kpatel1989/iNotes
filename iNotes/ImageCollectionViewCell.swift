//
//  ImageCollectionViewCell.swift
//  iNotes
//
//  Created by Kartik Patel on 2017-04-25.
//  Copyright © 2017 Kartik Patel. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var locationCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
