//
//  AddResponseTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 31/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class AddResponseTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Customize TextView
        questionTextView.layer.borderColor = UIColor.lightTheme().cgColor
        questionTextView.layer.borderWidth    = 2.0
        questionTextView.backgroundColor      = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
