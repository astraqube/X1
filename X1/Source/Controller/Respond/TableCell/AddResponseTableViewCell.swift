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
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
