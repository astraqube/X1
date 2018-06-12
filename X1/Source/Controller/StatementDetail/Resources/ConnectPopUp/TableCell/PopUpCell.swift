//
//  PopUpCell.swift
//  Solviant
//
//  Created by Sushil Mishra on 07/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PopUpCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var solveViaConferenceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectDurationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareViaEmailButton: UIButton!
    @IBOutlet weak var selectDurationButton: UIButton!
    @IBOutlet weak var shareViaConferenceCallButton: UIButton!
    
    @IBOutlet weak var solveSubView: UIView!
    
    @IBOutlet weak var shareViaEmailView: UIView!
    @IBOutlet weak var shareViaConferenceView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
