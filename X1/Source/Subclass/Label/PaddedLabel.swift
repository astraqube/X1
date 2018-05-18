//
//  PaddedLabel.swift
//  Solviant
//
//  Created by Rohit Kumar on 17/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
