//
//  SideMenuOptionTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 13/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class SideMenuOptionTableViewCell: UITableViewCell {

    // MARK: - IB Outlet
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
