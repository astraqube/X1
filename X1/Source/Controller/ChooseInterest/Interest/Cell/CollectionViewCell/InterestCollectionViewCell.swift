//
//  InterestCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 07/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeUI()
    }

    // MARK: - Utility
    
    private func customizeUI() {
        itemTitleLabel.layer.cornerRadius  = 2
        itemTitleLabel.layer.masksToBounds = true
        itemTitleLabel.layer.borderColor   = UIColor.darkGray.cgColor
        itemTitleLabel.layer.borderWidth   = 1.0
    }
}
