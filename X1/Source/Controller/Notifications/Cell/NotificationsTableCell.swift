//
//  NotificationsTableCell.swift
//  Solviant
//
//  Created by Sushil Mishra on 11/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class NotificationsTableCell: UITableViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailView.darkShadow(withRadius: 6.0, color: UIColor.black.withAlphaComponent(0.3))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
