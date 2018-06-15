//
//  PostUrgencyTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 25/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PostUrgencyTableViewCell: UITableViewCell {

    @IBOutlet weak var urgencyTitleLabel: UILabel!
    @IBOutlet weak var urgencySubTitleLabel: UILabel!
    @IBOutlet weak var urgencyValidDuration: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
