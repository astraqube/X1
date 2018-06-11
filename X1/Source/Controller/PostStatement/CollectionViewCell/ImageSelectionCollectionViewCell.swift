//
//  ImageSelectionCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 08/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ImageSelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius  = 4
        self.containerView.layer.masksToBounds = true
        self.closeButton.layer.cornerRadius  = self.closeButton.frame.size.width/2
        self.closeButton.layer.masksToBounds = true
        self.closeButton.backgroundColor     = .white
    }
}
