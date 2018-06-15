//
//  RedefinedStatementTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 15/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RedefinedStatementTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var problemStatementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
