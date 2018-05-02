//
//  ProfileTextFieldTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 01/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ProfileTextFieldTableViewCell: UITableViewCell {

    
    @IBOutlet weak var inputTextField: SkyFloatingLabelTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
