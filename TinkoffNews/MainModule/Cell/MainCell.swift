//
//  MainCell.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 27.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        title.adjustsFontSizeToFitWidth = true
        title.lineBreakMode = .byWordWrapping
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        title.sizeToFit()
        layoutAttributes.size.height = title.frame.height + date.frame.height + 32
        return layoutAttributes
    }
    
}
