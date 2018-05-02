//
//  ProfileDoneButtonTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 01/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ProfileDoneButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var completeProfileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func customizeUI() {
        // Set border for Button
        completeProfileButton.backgroundColor = .white
        completeProfileButton.darkShadow(withRadius: 10)
        completeProfileButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        completeProfileButton.layer.sublayers?.last?.cornerRadius = 7.0
        completeProfileButton.layer.sublayers?.last?.masksToBounds = true
    }

}
