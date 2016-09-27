//
//  BrochureCell.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import UIKit

class BrochureCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var retailerNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }
}
