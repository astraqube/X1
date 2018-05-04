//
//  SubcategoryCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 04/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class SubcategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subcategoryImageView: UIImageView!
    @IBOutlet weak var subcategoryTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subcategoryImageView.layer.cornerRadius  = 5
        subcategoryImageView.layer.masksToBounds = true
        subcategoryTitleLabel.layer.cornerRadius = 4
        subcategoryTitleLabel.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subcategoryTitleLabel.backgroundColor = .clear
        subcategoryTitleLabel.textColor       = .darkGray
    }

}
