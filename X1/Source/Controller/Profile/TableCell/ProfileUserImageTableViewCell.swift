//
//  ProfileUserImageTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 01/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ProfileUserImageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius    = userImageView.frame.size.width/2
        userImageView.layer.masksToBounds   = true
        userImageView.contentMode           = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func customizeUI() {
        // Customize background and border
        maleButton.backgroundColor = .white
        maleButton.darkShadow(withRadius: 10)
        femaleButton.backgroundColor = .white
        femaleButton.darkShadow(withRadius: 10)
//        maleButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        maleButton.setTitleColor(.white, for: .normal)
        maleButton.layer.sublayers?.last?.cornerRadius = maleButton.frame.size.width/2
        maleButton.layer.sublayers?.last?.masksToBounds = true
    }
    
    func toggleSelection(_ sender: UIButton, _ animated: Bool) {
        // Set border for Button
        if sender == femaleButton {
            femaleButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
            femaleButton.layer.sublayers?.last?.cornerRadius = femaleButton.frame.size.width/2
            femaleButton.layer.sublayers?.last?.masksToBounds = true
            for layer in maleButton.layer.sublayers! {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
            maleButton.setTitleColor(UIColor.darkTheme(), for: .normal)
            femaleButton.setTitleColor(.red, for: .selected)
            femaleButton.setTitle("F", for: .selected)
            femaleButton.isSelected = true
            maleButton.isSelected   = false
        }
        else {
//            maleButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
            maleButton.layer.sublayers?.last?.cornerRadius = maleButton.frame.size.width/2
            maleButton.layer.sublayers?.last?.masksToBounds = true
            for layer in femaleButton.layer.sublayers! {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
            femaleButton.setTitleColor(UIColor.darkTheme(), for: .normal)
            maleButton.setTitleColor(.red, for: .selected)
            maleButton.setTitle("M", for: .selected)
//            maleButton.isSelected   = true
//            femaleButton.isSelected = false
        }
        
        // Scale with damping
        guard animated else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            sender.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }) { (status) in
            // Completion Block
            sender.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }

}
