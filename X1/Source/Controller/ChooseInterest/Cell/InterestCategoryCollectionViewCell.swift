//
//  InterestCategoryCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 03/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class InterestCategoryCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var cotainerView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Customize UI
        customizeUI()
    }
    
    private func customizeUI() {
        // Set appearance for cell
//        cotainerView.darkShadow(withRadius: 20)
        self.darkShadow(withRadius: 2)
        cotainerView.layer.borderWidth   = 3.0
        cotainerView.layer.borderColor   = UIColor.white.cgColor
    }
    
}
