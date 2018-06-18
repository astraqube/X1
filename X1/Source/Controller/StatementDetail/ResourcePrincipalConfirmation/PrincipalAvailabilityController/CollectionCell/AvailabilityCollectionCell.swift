//
//  AvailabilityCollectionCell.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class AvailabilityCollectionCell: UICollectionViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var availabilityTimeLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailView.layer.borderWidth = 1.0
        detailView.layer.cornerRadius = self.detailView.frame.size.height/2
        detailView.layer.borderColor = UIColor.lightTheme().cgColor
        detailView.darkShadow(withRadius: 5)
    }
    
}
