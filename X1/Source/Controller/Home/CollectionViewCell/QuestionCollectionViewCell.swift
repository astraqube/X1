//
//  QuestionCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 11/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.darkShadow(withRadius: 5)
    }
}
